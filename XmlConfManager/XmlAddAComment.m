function [ file, root ] = XmlAddAComment( file, root, comment )
%XMLADDACOMMENT Summary of this function goes here
%   Detailed explanation goes here
root.appendChild(file.createComment(comment));

end

