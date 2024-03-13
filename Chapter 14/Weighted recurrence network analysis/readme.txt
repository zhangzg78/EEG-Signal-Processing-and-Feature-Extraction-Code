1. Run "install.m" to construct a network.

2. Run "joint_recurrence_cn.m" under the folder "1_construct_network":
For each of the 10 segments of each subject under each state, construct the weighted recurrence network respectively, and save the obtained networks respectively. All obtained networks are saved in the folder "2_indicators".

3. Run "CC_area.m" under the folder "2_indicators", in which the "2015_01_25 BCT" folder needs to be added to the path in Matlab. "2015_01_25 BCT" contains the functions to calculate weighted global efficiency and local efficiency. The calculated indicators are saved into the folder "3_t_test" separately for each subject and for each state.

4. Run "anovatest.m" under "3_t_test" folder to perform the t-test and obtain p-values. Save p-values into an excel file with filename starting with "anova". The results of each subject are saved respectively.


