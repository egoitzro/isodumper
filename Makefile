# Copyright (C) 2013 THE isodumper'S COPYRIGHT HOLDER
# This file is distributed under the same license as the isodumper package.

# This Makefile is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY, to the extent permitted by law; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.

# Author isodumper software= papoteur <papoteur@mageialinux-online.org>
# Author Makefile file= Geiger David <david.david@mageialinux-online.org>

PREFIX=/usr/local
BINDIR=$(PREFIX)/bin
SBINDIR=$(PREFIX)/sbin
LIBDIR=$(PREFIX)/lib
DATADIR=$(PREFIX)/share
ICONSDIR=$(PREFIX)/share/icons
PIXMAPSDIR=$(PREFIX)/share/pixmaps
LOCALEDIR=$(PREFIX)
DOCDIR=$(PREFIX)/share/doc/isodumper
PYTHON=/usr/bin/env python


all: isodumper COPYING CHANGELOG


clean:
	rm -f isodumper COPYING CHANGELOG


install: all

	# for binary file isodumper on /usr/sbin/
	mkdir -p $(DESTDIR)$(SBINDIR)
	install -m 755 isodumper $(DESTDIR)$(SBINDIR)
	# Adjust for console-helper magic
	mkdir -p $(DESTDIR)$(BINDIR)
	cd $(DESTDIR)$(BINDIR); ln -s consolehelper isodumper

	# for LIBFILES isodumper.py find_devices
	mkdir -p $(DESTDIR)$(LIBDIR)/isodumper
	install -m 755 lib/find_devices $(DESTDIR)$(LIBDIR)/isodumper
	install -m 755 lib/isodumper.py $(DESTDIR)$(LIBDIR)/isodumper

	# for DATADIR isodumper.py header.png
	mkdir -p $(DESTDIR)$(DATADIR)/isodumper
	install -m 644 share/isodumper/isodumper.glade $(DESTDIR)$(DATADIR)/isodumper
	install -m 644 share/isodumper/header.png $(DESTDIR)$(DATADIR)/isodumper

	# for isodumper desktop menu entry
	mkdir -p $(DESTDIR)$(DATADIR)/applications
	install -m 644 share/applications/isodumper.desktop $(DESTDIR)$(DATADIR)/applications

	# for isodumper doc 
	mkdir -p $(DESTDIR)$(DOCDIR)
	install -m 644 COPYING CHANGELOG README.md i18n.md $(DESTDIR)$(DOCDIR)

	# for isodumper icons
	#NOTE: You must install imagemagick package.
	mkdir -p $(DESTDIR)$(ICONSDIR)
	convert isodumper.png -geometry 32x32 $(DESTDIR)$(ICONSDIR)/isodumper.png
	mkdir -p $(DESTDIR)$(ICONSDIR)/mini
	convert isodumper.png -geometry 20x20 $(DESTDIR)$(ICONSDIR)/mini/isodumper.png
	mkdir -p $(DESTDIR)$(ICONSDIR)/large
	convert isodumper.png -geometry 48x48 $(DESTDIR)$(ICONSDIR)/large/isodumper.png
	mkdir -p $(DESTDIR)$(PIXMAPSDIR)
	install -m 644 isodumper.png $(DESTDIR)$(PIXMAPSDIR)

	# for isodumper.mo translations
	for locale in share/locale/*; \
	do \
	mkdir -p $(DESTDIR)$(LOCALEDIR)/$$locale/LC_MESSAGES; \
	install -m 644 $$locale/LC_MESSAGES/isodumper.mo $(DESTDIR)$(LOCALEDIR)/$$locale/LC_MESSAGES/isodumper.mo; \
	done


tar: isodumper.tar.gz


README.txt: README.md
	pandoc -f markdown -t plain README.md -o README.txt


i18n.txt: i18n.md
	pandoc -f markdown -t plain i18n.md -o i18n.txt