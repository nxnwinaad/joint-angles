function tree = treeFindChildren(tree)

% BY - Shashi Mohan Singh (edited)| 2018 | University of Washington | IITGN
% TREEFINDCHILDREN Given a tree that lists only parents, add children.
% Description:
% TREE = TREEFINDCHILDREN(TREE) takes a tree structure which lists the
% children of each node and computes the parents for each node and places them in.
% Returns:
% TREE - a tree that lists children and parents.
% Arguments:
% TREE - the tree that lists only children.
% See also: TREEFINDPARENTS


for i = 1:length(tree)
  for j = 1:length(tree(i).parent)
    if tree(i).parent(j)
      tree(tree(i).parent(j)).children ...
          = [tree(tree(i).parent(j)).children i];
    end
  end
end

