

function [TR]= TR(adj) 

Spar = 0.1:0.01:0.35;
N_Spar = length(Spar);

T_62 = zeros(1,N_Spar);% Transitivity
  
    
    for n = 1:N_Spar
        Mat_spar = threshold_proportional(adj,Spar(n));
       
        T_62(1,n) =transitivity_wu(Mat_spar);
               
    end
    % ------ calculating integral
   
    TR = trapz(Spar,T_62(1,:));
   
end
    



