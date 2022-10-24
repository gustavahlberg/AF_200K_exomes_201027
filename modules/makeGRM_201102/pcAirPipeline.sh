#
#
# Run 
# created: 201102
#
# ----------------------------------------------------
#
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR


# ----------------------------------------------------
#
# King
#

#Rscript ${DIR}/King.R


# ----------------------------------------------------
#
# King
#

#Rscript ${DIR}/makeSparseKing.R


# ----------------------------------------------------
#
# PC-AiR
#

Rscript ${DIR}/pcair.R

# ----------------------------------------------------
#
# PC-Relate
#


#. ${DIR}/pcRelate.sh

#Rscript ${DIR}/pcRelate.R
