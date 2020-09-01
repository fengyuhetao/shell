#!/bin/bash

#创建4个sh

for (( i=1; i<=4; i++))
do
	touch $i.sh
	echo '#!/bin/bash' > $i.sh
	chmod 764 $i.sh
done
