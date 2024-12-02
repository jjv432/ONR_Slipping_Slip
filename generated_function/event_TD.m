function [value,isterminal,direction] = event_TD(t,in2,theta0)
%event_TD
%    [VALUE,ISTERMINAL,DIRECTION] = event_TD(T,IN2,THETA0)

%    This function was generated by the Symbolic Math Toolbox version 24.1.
%    02-Dec-2024 14:48:37

y2 = in2(2,:);
value = y2-sin(theta0)./2.0;
if nargout > 1
    isterminal = 1.0;
end
if nargout > 2
    direction = -1.0;
end
end
