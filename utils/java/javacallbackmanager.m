classdef javacallbackmanager < handle
% Helper functions for interfacing with java object callbacks.
% Do not forget to rmCallback() before deleting concerned objects or
% they will stay in memory and 'clear classes' will fail.
% Can be set as superclass or as standalone property
% m = javacallbackmanager(javaObj);
%   see m.callback_list for list of possible callbacks
%   if defined as a superclass, use .populateCallbacks(javaObj) in the class initialization
% .setCallback(target,callback)
%   define callback on java event target
%   target must be a member of callback_list
% .setMethodCallback(target)
%   for use when javacallbackmanager is a superclass of class A.
%   When triggered, the class A method named target is called
% .rmCallback(target)
%   remove a previously defined callback
%   if no argument, remove every callbacks

    properties(SetAccess=protected,Abstract)
        java
    end

    properties(SetAccess=protected)
        JEvents_list
    end

    properties(Dependent)
        JEvents
    end
    
    properties(Access=private)
        jcbhandle
        iJEvents = {}
    end
    
    methods
        
        function obj = javacallbackmanager()
            obj.jcbhandle = obj.java.handle('CallbackProperties');
            fn = fieldnames(obj.jcbhandle);
            fn = fn(endsWith(fn,'CallbackData'));
            obj.JEvents_list = extractBefore(fn,'CallbackData');
        end

        function set.JEvents(obj,evts)
            evts = cellstr(evts);
            evts = unique(evts(:),'stable');
            tf = ismember(evts,obj.JEvents_list);
            if ~all(tf)
                error('Java callback not found: %s',strjoin(evts(~tf),', '));
            end

            tf = ismember(evts,events(obj));
            if ~all(tf)
                error('Event not found: %s',strjoin(evts(~tf),', '));
            end

            obj.rmJEvents;
            obj.iJEvents = evts;
            for i=1:numel(evts)
                obj.jcbhandle.([evts{i} 'Callback']) = @(src,evt) notify(obj,evts{i},javaevent(evt));
            end
        end

        function evts = get.JEvents(obj)
            evts = obj.iJEvents;
        end

        function addJEvents(obj,evts)
            evts = cellstr(evts);
            obj.JEvents = [obj.iJEvents ; evts(:)];
        end

        function rmJEvents(obj,evts)
            if nargin < 2
                evts = obj.iJEvents;
            end
            evts = cellstr(evts);
            [tf,k] = ismember(evts,obj.iJEvents);
            evts = evts(tf);
            for i=1:numel(evts)
                obj.jcbhandle.([evts{i} 'Callback']) = [];
            end
            obj.iJEvents(k(tf)) = [];
        end

        function delete(obj)
            obj.rmJEvents;
        end
        
    end
end

