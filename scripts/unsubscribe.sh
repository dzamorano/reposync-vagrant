#!/bin/bash

# Cleaning up tmp
rm -rf /tmp/*
rm -rf /var/tmp/*

# Remove cache 
rm -rf /var/cache/*

# Cleanup subscription-manager
yum clean all
subscription-manager remove --all
subscription-manager unregister
subscription-manager clean