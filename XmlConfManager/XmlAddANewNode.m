function [ docNode, docRootNode, newElement ] ...
    = XmlAddANewNode( docNode, docRootNode, name, value )
%XMLCREATENEWNODE Summary of this function goes here
%   Detailed explanation goes here

NOVALUE = false;
switch nargin
    case 3
        NOVALUE = true;
    case 4
    otherwise
        error('Not right number of input arguments!');
end
newElement = docNode.createElement(name);
docRootNode.appendChild(newElement);

if NOVALUE
else
    newElement.appendChild(docNode.createTextNode(value));
end

end

