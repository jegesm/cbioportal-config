
cd /studies

for f in coadread_dfci_2016 coadread_genentech coadread_tcga_pub coadread_tcga coadread_mskcc crc_msk_2018
do
	wget http://download.cbioportal.org/$f".tar.gz"
	mkdir $f
	cd $f
	tar -xf ../$f.tar.gz
	./validateData.py -s ./ -n
	metaImport.py -s ./ -n -o
        cd ..
done


