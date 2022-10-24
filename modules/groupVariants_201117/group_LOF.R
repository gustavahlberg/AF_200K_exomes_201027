#
# Grouping rare missense variants
#
# criteria:
# 
#
#
# ---------------------------------------------
#
# load
#

# chr <- 2
load(paste0("results/infotab_chr", chr, ".Rdata"), verbose = T)

# tab_list <- split(tab$Gene_ID, tab)

maf_thres <- 1e-4
tab$gnomad_popmax_af[is.na(tab$gnomad_popmax_af)] <- 0


# ---------------------------------------------
#
# filter maf
#
# a) internal

if (any(tab$maf == 0))
    tab <- tab[-which(tab$maf == 0), ]

tab_intmaf <- tab[tab$maf < maf_thres, ]


# b) external

tab_intextmaf <- tab_intmaf[tab_intmaf$maf < maf_thres, ]

# ---------------------------------------------
#
# filter to LOF
#

tab_intextmaf$dbscSNV.rf_score[tab_intextmaf$dbscSNV.rf_score == "."] <- 0
tab_intextmaf$dbscSNV.rf_score[is.na(tab_intextmaf$dbscSNV.rf_score)] <- 0
tab_intextmaf$dbscSNV.ada_score[is.na(tab_intextmaf$dbscSNV.ada_score)] <- 0

sum(tab_intextmaf$Annotation_Impact == "HIGH" |
    (as.numeric(tab_intextmaf$dbscSNV.rf_score) > 0.8 &
     tab_intextmaf$dbscSNV.ada_score > 0.8))


idxLOF <- which(tab_intextmaf$Annotation_Impact == "HIGH" |
                (as.numeric(tab_intextmaf$dbscSNV.rf_score) > 0.8 &
                 tab_intextmaf$dbscSNV.ada_score > 0.8))

tab_lof <- tab_intextmaf[idxLOF, ]


# ---------------------------------------------
#
# add weights
#


weightFromCaddPhred <- function(phred, weight_beta = c(1, 15)){
    dbeta(10^(-phred/10), weight_beta[1], weight_beta[2])
}

tab_lof$weights <- weightFromCaddPhred(tab_lof$PHRED, weight_beta = c(1, 30))


# ---------------------------------------------
#
# make set file
#


set <- data.frame(set = paste0(tab_lof$Gene_ID, "_", tab_lof$Gene_Name),
                  chr = tab_lof$seqnames,
                  pos = tab_lof$start,
                  ref = tab_lof$ref,
                  alt = tab_lof$alt,
                  weights = tab_lof$weights
                  )


# ---------------------------------------------
#
# Special TTN case
#

if (chr == 2) {

    tab_ttn <- tab_lof[tab_lof$Gene_ID == "ENSG00000155657", ]
    # in N2BA/N2B
    tab_ttn_ciso <- tab_ttn[tab_ttn$Feature_ID %in% c("ENST00000591111.5", "ENST00000460472.6"), ]
    # PSI 90
    psitab <- read.table("../../data/TTNpsi.csv", sep = ",")
    psiexons <- paste0(na.omit(psitab$V1[as.numeric(psitab$V13) >= 90 ]), "/363")
    tab_ttn_psi <- tab_ttn[tab_ttn$Feature_ID %in% c("ENST00000589042.5"), ]
    tab_ttn_psi <- tab_ttn_psi[tab_ttn_psi$Rank %in% psiexons, ]

    set_ciso <- data.frame(set = "TTN_N2BA_N2B",
                           chr = tab_ttn_ciso$seqnames,
                           pos = tab_ttn_ciso$start,
                           ref = tab_ttn_ciso$ref,
                           alt = tab_ttn_ciso$alt,
                           weights = tab_ttn_ciso$weights
                           )
    set_ciso <- unique(set_ciso)

    set_psi <- data.frame(set = "TTN_PSI90",
                          chr = tab_ttn_psi$seqnames,
                          pos = tab_ttn_psi$start,
                          ref = tab_ttn_psi$ref,
                          alt = tab_ttn_psi$alt,
                          weights = tab_ttn_psi$weights
                          )
    set_psi <- unique(set_psi)
    
}



# ---------------------------------------------
#
# save set file
#


set <- unique(set)
if (chr == 2) set <- rbind(set, set_ciso, set_psi)

set_path <- "groups/group_LOF/"
set_fn <- paste0(set_path, "set_w_lof_chr", chr, ".txt")

write.table(file = set_fn,
            x = set,
            row.names = FALSE,
            col.names = FALSE,
            quote = FALSE,
            sep = "\t"
            )


set$weights <- 1
set_path <- "groups/group_LOF/"
set_fn <- paste0(set_path, "set_lof_chr", chr, ".txt")

write.table(file = set_fn,
            x = set,
            row.names = FALSE,
            col.names = FALSE,
            quote = FALSE,
            sep = "\t"
            )


