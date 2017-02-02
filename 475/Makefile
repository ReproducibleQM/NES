RAWPAGES := pages.txt
VARPAGES := $(shell cat ${RAWPAGES})
CLEANPAGES := pages_clean.txt
CLEANNAMES := $(shell cat ${CLEANPAGES})

PAGENUMS := $(basename $(notdir ${VARPAGES}))

test:
	echo $(VARPAGES)
	echo $(CLEANNAMES)

csvs: $(VARPAGES)
	echo ocr done

%.csv:
	Rscript -e 'write.csv(nesR::nes_get( '\
	'system.file("extdata/national-eutrophication-survey_$(PDFSOURCE).PDF", '\
	'package = "nesR"), $(basename $@)), "$@", row.names = FALSE)'

cleancsvs: $(CLEANNAMES)
	echo parse done

%_clean.csv: %.csv
	-Rscript -e 'write.csv(cbind(pagenum = "$(shell printf "%03g" ${basename $(notdir $<)})", nesR::parse_nes( '\
	'read.csv("$<", stringsAsFactors = FALSE)[,1])), "$@", row.names = FALSE)'

$(PDFSOURCE)/res.csv: cleancsvs
	Rscript -e 'flist <- list.files(pattern  = "clean.csv", include.dirs = TRUE); res <- do.call("rbind", lapply(flist, function(x) read.csv(x, stringsAsFactors = FALSE, colClasses = "character"))); res <- res[order(res[,"pagenum"]),]; write.csv(res, "res.csv", row.names = FALSE)'

all: $(PDFSOURCE)/res.csv
