function [ file, root ] = XmlInit( rootName )
%XMLINIT Summary of this function goes here
%   Detailed explanation goes here
file = com.mathworks.xml.XMLUtils.createDocument(rootName);
root = file.getDocumentElement;

end

