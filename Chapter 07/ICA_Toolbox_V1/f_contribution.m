function [sort_PowerOfComp_single_ratio sort_PowerOfComp_multiple_ratio sort_PowerOfComp Idx ]=f_contribution(PowerOfComp)

  [sort_PowerOfComp Idx] = sort(PowerOfComp,'descend') ;
   s = sum(sort_PowerOfComp) ;
   for isComp = 1:length(PowerOfComp)
    sort_PowerOfComp_single_ratio(isComp) = sum(sort_PowerOfComp(isComp))/s *100 ;
    sort_PowerOfComp_single_ratio(isComp) = roundn(sort_PowerOfComp_single_ratio(isComp),-2) ;
    sort_PowerOfComp_multiple_ratio(isComp) = sum(sort_PowerOfComp(1:isComp))/s *100 ;
    sort_PowerOfComp_multiple_ratio(isComp) = roundn(sort_PowerOfComp_multiple_ratio(isComp),-2) ;
   end
end