
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhclient-script.PATH.diff

patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-remove-bind.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-remove-dst.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-sharedlib.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-errwarn-message.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-dhclient-options.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-release-by-ifup.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-dhclient-decline-backoff.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-unicast-bootp.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-default-requested-options.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-xen-checksum.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-manpages.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-paths.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-CLOEXEC.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-garbage-chars.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-add_timeout_when_NULL.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-64_bit_lease_parse.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-capability.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-logpid.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-UseMulticast.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-sendDecline.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-retransmission.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-rfc3442-classless-static-routes.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-honor-expired.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-PPP.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-paranoia.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-lpf-ib.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-improved-xid.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-gpxe-cid.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-dhclient-decline-onetry.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-log_perror.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-getifaddrs.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-omapi-leak.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-rfc5970-dhcpv6-options-for-network-boot.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-failOverPeer.patch 
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-interval.patch 
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-conflex-do-forward-updates.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-dupl-key.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-range6.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-next-server.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-bindtodevice-inet6.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-no-subnet-error2info.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/dhcp-ffff-checksum.patch

# Set to YES if autogen is needed
SB_AUTOGEN=YES

set +e +o pipefail
