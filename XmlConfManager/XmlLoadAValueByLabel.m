function [ value ] = XmlLoadAValueByLabel( xmlFileName, label )
%XMLLOADVALUEBYLABEL Summary of this function goes here
%   Detailed explanation goes here
tree = xmlread(xmlFileName);
node = tree.getElementsByTagName(label);
switch node.getLength
    case 1
        value = char(node.item(0).getFirstChild.getData);
    case 0
        error('Cannot find the node!');
    otherwise
        error('Too many nodes');
end

end

