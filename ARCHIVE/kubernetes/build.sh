BUILDDIR=raw
MANIFEST=manifest

mkdir -p ${BUILDDIR} ${MANIFEST} 

cd ${BUILDDIR}

for f in `ls ../*.jsonnet`
do
	sf=$(echo $f | tr "." " " | awk '{print $1}')
	jsonnet -m . $f; 
done

for f in `ls *-raw`
do
	sf=$(echo $f | tr "-" " " | awk '{print $1}')
	cat ${f} | gojsontoyaml > ../${MANIFEST}/${sf}
done

cd ..
