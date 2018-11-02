function ind = treeFindLeaves(tree)

% BY - Shashi Mohan Singh (edited)| 2018 | University of Washington | IITGN
% TREEFINDLEAVES Return indices of all leaf nodes in a tree structure.

% Description:
% IND = TREEFINDLEAVES(TREE) returns indices of all leaf nodes in an
% tree array.
% Returns:
% IND - indices of leaf nodes.
% Arguments:
% TREE - tree for which leaf nodes are being sought.
% See also: TREEFINDPARENTS, TREEFINDCHILDREN

ind = [];
for i = 1:length(tree)
  if isempty(tree(i).children)
    ind = [ind i];
  end
end