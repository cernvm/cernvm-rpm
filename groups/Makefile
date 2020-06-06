
packages: $(wildcard bits/*)
	#  xorgxrdp requires xorg server version that is not yet..? there... cat bits/gui.test | sort -u > packages
	cat bits/minimal bits/base bits/more bits/head bits/debug bits/perl bits/mono \
	  bits/nodejs bits/gui bits/xfce bits/cernvm bits/i686-extra bits/jade bits/eos \
          | sort -u > packages

clean:
	rm -f packages

