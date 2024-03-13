
A few notes:
1. EEGlab and function_icasso_component Toolbox should be added to MATLAB path in advance

2. Run "m1": 
first load data, you can get sample data from: "data--> Sub1 --> data.set" (for compatibility with EEGLab, the default input format of the toolbox is .set)

3. Select the ICs to be deleted from the drawn image, and enter these ICs into the dialog box. A file named "Reject_EOG.set" (with EOG artifact removed) will be generated under the subject file.

4. When running "m2" for the first time, you should choose to visualize each component, that is, choose 2 in the 3rd line; 
afterwards, an "ICA_Comp" folder will be generated in ICA result folder under the subject folder, and all component results will be saved in the form of images.
run "m2" again, you can enter the ICs to be deleted without visualizing the components