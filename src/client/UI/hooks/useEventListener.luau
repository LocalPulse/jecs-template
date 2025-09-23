local React = require(game.ReplicatedStorage.Packages.React)
local useLatest = require(script.Parent.useLatest).useLatest

export type EventListenerOptions = {
	connected: boolean?,
	once: boolean?,
}

type ConnectionLike =
	RBXScriptConnection
	| (() -> ())
	| { Disconnect: (self: any) -> () }
	| { disconnect: (self: any) -> () }
type EventLike =
	RBXScriptSignal
	| { Connect: (self: any, (...any) -> ()) -> ConnectionLike }
	| { connect: (self: any, (...any) -> ()) -> ConnectionLike }
	| { subscribe: (self: any, (...any) -> ()) -> ConnectionLike }

local function connectEvent(event: EventLike, callback: (...any) -> ())
	if typeof(event) == "RBXScriptSignal" then
		local connection: RBXScriptConnection
		connection = (event :: RBXScriptSignal):Connect(function(...)
			if connection.Connected then
				callback(...)
			end
		end)
		return connection
	elseif type(event) == "table" then
		if event.Connect then
			return event:Connect(callback)
		elseif event.connect then
			return event:connect(callback)
		elseif event.subscribe then
			return event:subscribe(callback)
		end
	end
	error("Unsupported event-like object")
end

local function disconnectConnection(conn: ConnectionLike)
	local t = typeof(conn)
	if t == "function" then
		(conn :: any)()
	elseif t == "RBXScriptConnection" then
		(conn :: RBXScriptConnection):Disconnect()
	elseif type(conn) == "table" then
		if conn.Disconnect then
			conn:Disconnect()
		elseif conn.disconnect then
			conn:disconnect()
		else
			error("Unsupported connection table")
		end
	else
		error("Unknown connection type")
	end
end

local function useEventListener(event: EventLike?, listener: ((...any) -> ())?, options: EventListenerOptions?)
	local opts = options or {}
	local once = opts.once == true
	local shouldConnect = opts.connected ~= false
	local listenerRef = useLatest(listener)

	React.useEffect(function()
		if not event or not listener or not shouldConnect then
			return
		end

		local canDisconnect = true
		local connection: ConnectionLike? = nil

		connection = connectEvent(event, function(...)
			if once and connection then
				disconnectConnection(connection)
				canDisconnect = false
			end
			local fn = listenerRef.current
			if fn then
				fn(...)
			end
		end)

		return function()
			if canDisconnect and connection then
				disconnectConnection(connection)
			end
		end
	end, { event, shouldConnect, listener ~= nil })
end

return {
	useEventListener,
}
