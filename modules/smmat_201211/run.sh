#
# send jobs
# 


qsub -F "lof" -t 1-22 SMMAT.pbs
qsub -F "lof_w" -t 1-22 SMMAT.pbs
qsub -F "lof_smmat" -t 1-22 SMMAT.pbs

qsub -F "missense" -t 1-22 SMMAT.pbs
qsub -F "missense_w" -t 1-22 SMMAT.pbs
qsub -F "missense_skat" -t 1-22 SMMAT.pbs
qsub -F "missense_skat_w" -t 1-22 SMMAT.pbs



# HF
qsub -F "lof" -t 1-22 SMMAT.pbs
