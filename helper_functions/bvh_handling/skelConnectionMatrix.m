function connection = skelConnectionMatrix(skel)

% BY - Shashi Mohan Singh (edited)| 2018 | University of Washington | IITGN
% SKELCONNECTIONMATRIX Compute the connection matrix for the structure.
% DESC computes the connection matrix for the structure. Returns a matrix
% which has zeros at all entries except those that are connected in the
% skeleton.
% ARG skel : the skeleton for which the connectivity is required.
% RETURN connection : connectivity matrix.
% SEEALSO : skelVisualise, skelModify

connection = zeros(length(skel.tree));
for i = 1:length(skel.tree);
  for j = 1:length(skel.tree(i).children)    
    connection(i, skel.tree(i).children(j)) = 1;
  end
end

