FROM debian:11

COPY icaclient_*.deb /tmp

RUN printf "%s\n" 'APT::Get::Install-Recommends "false";' 'APT::Get::Install-Suggests "false";' >> /etc/apt/apt.conf && \
	apt update && \
	DEBIAN_FRONTEND=noninteractive apt install -y firefox-esr xdg-utils /tmp/icaclient_*.deb && \
	rm /tmp/icaclient_*.deb && \
	ln -sr /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/ && \
	c_rehash /opt/Citrix/ICAClient/keystore/cacerts/ && \
	mkdir -p /root/.ICAClient/ && \
	touch /root/.ICAClient/.eula_accepted && \
	xdg-mime default wfica.desktop application/x-ica

COPY entrypoint.sh /
COPY prefs.js /prefs.js
ENTRYPOINT ["/entrypoint.sh"]
