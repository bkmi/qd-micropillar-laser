function [ hopf_branches ] = continue_hopf( branch, funcs, param, ...
    point_count, ind_new_contPar, continuation_settings, varargin )
%This function takes in a branch and then does a continuation along each
%potential hopf bifurcation. (diff in nunst==2).
%
%   Input:
%
%       ind_new_contPar: Can be given as [index] or [index1, index2]. If
%       one index is given then the free parameter from the input branch is
%       set as the xdirection continuation parameter [x, y, ind_omega].
%       However, if two are given then the continuation goes like the
%       following: [index1, index2, index_omega]. If you give multiple
%       indicies then DDE will try in the index2 direction first.
%
%       ( branch, funcs, point_count, param, ...
%         ind_new_contPar, continuation_settings, varargin )
%
%       continuation_settings = { 'step',0.01, ...
%                                 'minimal_accuracy',1e-4, ...
%                                 'min_bound',[ind_,1], ...
%                                 'max_bound',[ind_,2] }
%                       
%                       
%                   
%       
%   Options:
%       'ind_hopf' = [ 1, 2, ... ]
%           If ind_hopf is flagged then the function will only try to do
%           continuations at the points located at index == ind_hopf.
%


% Create an options struct from varargin, preserves cell arrays.
for i=1:length(varargin)
    if iscell(varargin{i})
        varargin{i}=varargin(i);
    end
end
options=struct(varargin{:});

% Organize behavior from options
% Check for ind_hopf
if isfield(options,'ind_hopf')
    ind_hopf = options.ind_hopf;
else
    nunst=GetStability(branch,'exclude_trivial',true,'locate_trivial',...
        @(p)0,'funcs',funcs);
    ind_hopf=find(abs(diff(nunst))==2);
end

% Create the hopf branch container, setup system
hopf_branches = struct;
ind_omega = length(branch.point(1).parameter);
figure
hold on

% Allow for one or two continuation params to be choosen
if length(ind_new_contPar)==1
    contpar = [branch.parameter.free(1),ind_new_contPar,ind_omega];
    direct = ind_new_contPar;
elseif length(ind_new_contPar)==2
    contpar = [ind_new_contPar(1), ind_new_contPar(2), ind_omega];
    direct = ind_new_contPar(2);
else
    error('ind_new_contPar must be length 1 or 2.')
end


% Generate a branch for each hopf bifurcation.
for i=1:length(ind_hopf)
    % Divide names into 1s, 10s, 100s
    if i<10
        actHopfBranch_name = strcat('h00',num2str(i),'branch');
    elseif i<100
        actHopfBranch_name = strcat('h0',num2str(i),'branch');
    else
        actHopfBranch_name = strcat('h',num2str(i),'branch');
    end
    
    hbranch.method.continuation.plot=1;
    
    try
      [hbranch,~]=SetupRWHopf(funcs,branch,ind_hopf(i),...
          'contpar',contpar,...
          'extra_condition',1,'print_residual_info',0,... %'print_residual_info',1
          'dir',direct, ... 
          continuation_settings{:});
      
      figure(gcf)
      hbranch=br_contn(funcs,hbranch,point_count);
      hbranch=br_rvers(hbranch);
      hbranch=br_contn(funcs,hbranch,point_count);
      
      % Only label the plot if a single ind_new_contPar is given.
      if length(ind_new_contPar)==1
          title(strcat(param.plot_names(ind_new_contPar),'-vs-',...
              param.plot_names(branch.parameter.free(1)),...
              '-Hopf Bifurcation Continuation'))
          xlabel([param.plot_names(branch.parameter.free(1)),...
              param.units(branch.parameter.free(1))])
          ylabel([param.plot_names(ind_new_contPar),...
              param.units(ind_new_contPar)])
      end
      
      hopf_branches.(actHopfBranch_name) = hbranch;
      disp(actHopfBranch_name)
      disp(hopf_branches)
      
    catch ME
        switch ME.identifier
            case 'br_contn:start'
                warning(ME.message);
                warning(strcat('During branch=',actHopfBranch_name));
                hopf_branches.(actHopfBranch_name).error = ME;
            otherwise
                rethrow(ME)
        end
    end
end

hold off


end

