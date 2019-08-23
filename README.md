# docker-openresty-oidc
> Luarocks + openresty + lua-resty-openidc in a minimal Alpine image (60MB)

- Public releases versions follow semver, matching lua-resty-openidc versioning, e.g. 1.7.2

- The official release that includes luarocks is 107MB: [openresty/openresty:alpine-fat](https://hub.docker.com/r/openresty/openresty/tags)

- Original Docker projects:
    - [zot24/openresty](https://hub.docker.com/r/zot24/openresty)
    - [zot24/openresty-luarocks](https://hub.docker.com/r/zot24/openresty-luarocks)

- OpenResty: http://openresty.org
- OpenID Connect LUA plugin: https://github.com/zmartzone/lua-resty-openidc
- [Removed] ~~lua-resty-xacml-pep library: https://github.com/zmartzone/lua-resty-xacml-pep~~

# TODO
- [ ] Run openresty as unpriviledged user, for improved security

# Changelog
- 2019-08-23 [1.7.2-1]:
    - Bumped versions:
        - luarocks: 3.1.3
        - openresty: 1.15.8.2
        - lua-resty-openidc: 1.7.2-1
    - Removed lua-resty-xacml-pep
- 2018-11-13:
    - Added lua-resty-hmac to prevent `state from argument: X does not match state restored from session Y` issue. See https://github.com/zmartzone/lua-resty-openidc/issues/213
- 2018-10-17:
    - Added library [lua-resty-xacml-pep](https://github.com/zmartzone/lua-resty-xacml-pep) to implement the XACML Policy Enforcement Point functionality using the REST and JSON Profiles of XACML 3.0
    - Upgraded luarocks version to 2.4.4 and changed download url to http://luarocks.github.io/luarocks/releases/luarocks-x.y.z.tar.gz
    - Added `--squash` to docker build
- 2018-10-04:
    - Updated OpenResty to 1.13.6.2 in Dockerfile
