#!/bin/bash
#
# slack-mirror-speedtest.sh
# Originally written for Ubuntu by Lance Rushing <lance_rushing@hotmail.com>
# Dated 9/1/2006
# Taken from http://ubuntuforums.org/showthread.php?t=251398
# This script is covered under the GNU Public License: http://www.gnu.org/licenses/gpl.txt
#
# Heavily modified for Slackware by Jeremy Brent Hansen <jebrhansen -at- gmail.com>
#
# NOTE: This won't work in Slackware 14.0 and earlier due to the OS lacking numfmt. It was
# introduced in the coreutils package in 14.1.
#
# Changelog
#
# 2016/07/07 - Updated MIRRORS variable to use EOF for easier copy/paste
# 2016/05/28 - Added additional comments for github upload
# 2015/11/06 - Initial release of slack-mirror-speedtest.sh

# Add or change mirrors from /etc/slackpkg/mirrors as desired (these are the US mirrors)
# Just place them between the read line and the EOF at the end. No quotes are necessary
read -r -d '' MIRRORS << 'EOF'
http://ftp.cc.swin.edu.au/slackware/slackware64-15.0/
http://ftp.iinet.net.au/pub/slackware/slackware64-15.0/
http://mirror.as24220.net/pub/slackware/slackware64-15.0/
http://mirror.internode.on.net/pub/slackware/slackware64-15.0/
http://gd.tuwien.ac.at/opsys/linux/freesoftware.com/slackware64-15.0/
http://mirror.datacenter.by/pub/slackware/slackware64-15.0/
http://ftp.slackware-brasil.com.br/slackware64-15.0/
http://mirrors.unixsol.org/slackware/slackware64-15.0/
http://mirror.csclub.uwaterloo.ca/slackware/slackware64-15.0/
http://mirror.its.dal.ca/slackware/slackware64-15.0/
http://mirrors.163.com/slackware/slackware64-15.0/
http://mirrors.ustc.edu.cn/slackware/slackware64-15.0/
http://mirrors.ucr.ac.cr/slackware/slackware64-15.0/
http://odysseus.linux.cz/pub/linux/slackware/slackware64-15.0/
https://mirrors.dotsrc.org/slackware/slackware64-15.0/
http://sunsite.informatik.rwth-aachen.de/ftp/pub/comp/Linux/slackware/slackware64-15.0/
http://patroklos.noc.ntua.gr/pub/linux/slackware/slackware64-15.0/
http://kambing.ui.ac.id/slackware/slackware64-15.0/
https://repo.ukdw.ac.id/slackware/slackware64-15.0/
http://ftp.heanet.ie/mirrors/ftp.slackware.com/pub/slackware/slackware64-15.0/
http://ba.mirror.garr.it/mirrors/Slackware/slackware64-15.0/
http://ftp.nara.wide.ad.jp/pub/Linux/slackware/slackware64-15.0/
http://riksun.riken.go.jp/Linux/slackware/slackware64-15.0/
http://mirrors.atviras.lt/slackware/slackware64-15.0/
https://mirrors.atviras.lt/slackware/slackware64-15.0/
http://ftp.nluug.nl/os/Linux/distr/slackware/slackware64-15.0/
http://mirror.nl.leaseweb.net/slackware/slackware64-15.0/
http://ftp.slackware.no/slackware/slackware64-15.0/
http://ftp.slackware.pl/pub/slackware/slackware64-15.0/
http://sunsite.icm.edu.pl/packages/linux-slackware/slackware64-15.0/
http://mirror.rol.ru/slackware/slackware64-15.0/
http://mirror.yandex.ru/slackware/slackware64-15.0/
http://ftp.is.co.za/mirror/ftp.slackware.com/pub/slackware64-15.0/
http://ftp.wa.co.za/pub/slackware/slackware64-15.0/
http://slackware.mirror.ac.za/slackware64-15.0/
http://ftp.sunet.se/mirror/slackware.com/slackware64-15.0/
https://mirror.init7.net/slackware/slackware64-15.0/
http://ftp.isu.edu.tw/pub/Linux/Slackware/slackware64-15.0/
http://ftp.twaren.net/Linux/Slackware/slackware64-15.0/
http://slackware.uk/slackware/slackware64-15.0/
http://ftp.mirrorservice.org/sites/ftp.slackware.com/pub/slackware/slackware64-15.0/
http://mirror.bytemark.co.uk/slackware/slackware64-15.0/
http://mirrors.us.kernel.org/slackware/slackware64-15.0/
http://mirrors.xmission.com/slackware/slackware64-15.0/
https://mirror.slackbuilds.org/slackware/slackware64-15.0/
http://slackware.cs.utah.edu/pub/slackware/slackware64-15.0/
http://slackware.mirrors.tds.net/pub/slackware/slackware64-15.0/
http://spout.ussg.indiana.edu/linux/slackware/slackware64-15.0/
EOF

# Use any adequetly sized file to test the speed. This is ~7MB.
# The location should be based on the relative location within
# the slackware64-current tree. I originally tried a smaller
# file (FILELIST.TXT ~1MB), but I was seeing slower speed results
# since it didn't have time to fully max my connection. Depending
# on your internet speed, you may want to try different sized files.
FILE="kernels/huge.s/bzImage"

# Number of seconds before the test is considered a failure
TIMEOUT="5"

# Clear the string that results are stored in
RESULTS=""

# Set color variables to make results and echo statements cleaner
RED="\e[31m"
GREEN="\e[32m"
NC="\e[0m"  #No color

for MIRROR in $MIRRORS ; do
	
  echo -n "Testing ${MIRROR} "
	
  # Combine the mirror with the file to create the URL
  URL="${MIRROR}${FILE}"

  # Time the download of the file
  SPEED=$(curl --max-time $TIMEOUT --silent --output /dev/null --write-out %{speed_download} $URL)

  # If the speed is below ~10kb/s mark it as a failure
  if (( $(echo "$SPEED < 10000.000" | bc -l) )) ; then
    echo -e "${RED}Fail${NC}";
  else 
    # Use numfmt to convert to a pretty speed
    SPEED="$(numfmt --to=iec-i --suffix=B --padding=7 $SPEED)ps"
    echo -e "${GREEN}$SPEED${NC}"
    RESULTS="${RESULTS}\t${SPEED}\t${MIRROR}\n";
  fi

done;

# Display a sorted list to the prompt
echo -e "\nResults:"
echo -e $RESULTS | sort -hr
