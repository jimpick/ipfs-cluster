#!/bin/sh

test_description="Test service startup and init functionality"

. lib/test-lib.sh

test_expect_success "ipfs setup" '
    test_ipfs_init &&
    test_have_prereq IPFS_INIT
'

test_expect_success "ipfs cluster setup" '
    test_cluster_init && 
    test_have_prereq CLUSTER_INIT
'

test_expect_success JQ "ipfs cluster config valid" '
    test_cluster_config
'

test_expect_success "custer-service help output looks good" '
    ipfs-cluster-service --help | egrep -q -i "^(Usage|Commands|Description|Global Options)"
'

test_expect_success "cluster-service --version succeeds and matches ctl" '
    export SERV_VERSION=`ipfs-cluster-service --version` &&
    export CTL_VERSION=`ipfs-cluster-ctl --version` &&
    echo "$SERV_VERSION" &&
    echo "$CTL_VERSION" &&
    sv=($SERV_VERSION) &&
    cv=($CTL_VERSION) &&
    [ "${sv[2]}" = "${cv[2]}" ]
'

cleanup test_clean_cluster 
cleanup test_clean_ipfs
test_done
