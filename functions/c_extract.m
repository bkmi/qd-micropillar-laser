function branch_extraction = c_extract(dde_branch, param_index)
% The continuation extractor converts the data points of a branch given in a path continuation by DDEBIF tool into a form useful for plotting |E|, rho, and n.
% Each data point from ddebif is a list of the soluton value (x) and parameters (par) at that point.
% 
% Input:
% 	dde_branch
% 		The branch from the continuation.
% 	param_index
% 		The indices of the parameters which are continued. The param_return will be reported in this order.
%
% Output:
% A struct with fields:
% 	.par
% 		A row of the parameter values which were continued. If you were going to plot solns vs parameter a row from param_return would be the x axis.
% 	.soln
% 		A row of column vector solutions to the equations given at the corresponding param_return index.
% 	.par_index
% 		The index used in the original parameter vector for each row. Just for clarity.
  
  
  % Prepare Parameters
  
  % parameter data is first stored in rows (like in ddebif)
  % point number = row number
  % parameter number = column number
  %
  %          par(1), par(2), par(3), ...
  % point(1)
  % point(2)
  % point(3)
  param_block = [];
  for i = 1:length(dde_branch.point)
    row_temp = dde_branch.point(i).parameter;
    param_block = [param_block; row_temp];
  end
  
  % parameter data is reported in rows (slightly different than in ddebif)
  % parameter number = row number
  %
  % point number = column number
  %        point(1), point(2), point(3), ...
  % par(1)
  % par(2)
  % par(3)
  param_block_trans = transpose(param_block);
  param_rows = [];
  for i = param_index
    row_temp = param_block_trans(i,:);
    param_rows = [param_rows; row_temp];
  end
  
  
  % Prepare Solns
  
  % soln data will be stored in columns (like in ddebif)
  % point number = column number
  % re(E), im(E), rho, n = (1,:), (2,:), (3,:), (4,:)
  %
  %       point(1), point(2), point(3), ...
  % re(E)
  % im(E)
  % rho
  % n
  soln_block = [];
  for i = 1:length(dde_branch.point)
    col_temp = dde_branch.point(i).x;
    soln_block = [soln_block, col_temp];
  end
  
  
  % Report/Return values 
  
  param_return = param_rows;
  soln_return = soln_block;
  
  if iscolumn(param_index)
    param_index_return = param_index;
  elseif iscolumn(transpose(param_index))
    param_index_return = transpose(param_index);
  else
    error('Your paramter index doesn`t make sense. You need to input a column or row vector.')
  end
  
  branch_extraction.par = param_return;
  branch_extraction.soln = soln_return;
  branch_extraction.par_index = param_index_return;
  
end