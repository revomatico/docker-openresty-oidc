# docker-openresty-oidc
> Openresty + luarocks + lua-resty-openidc + lua-resty-xacml-pep in a minimal Alpine image (59MB)

- The official release, 250MB+: [Openresty/openresty:alpine-fat](https://hub.docker.com/r/openresty/openresty/)

- Original Docker projects:
    - [zot24](https://hub.docker.com/u/zot24/)/openresty
    - [zot24](https://hub.docker.com/u/zot24/)/openresty-luarocks

- OpenResty: http://openresty.org
- OpenID Connect LUA plugin: https://github.com/zmartzone/lua-resty-openidc
- lua-resty-xacml-pep library: https://github.com/zmartzone/lua-resty-xacml-pep

# Changelog
- 2018-10-17:
    - Added library [lua-resty-xacml-pep](https://github.com/zmartzone/lua-resty-xacml-pep) to implement the XACML Policy Enforcement Point functionality using the REST and JSON Profiles of XACML 3.0
    - Upgraded luarocks version to 2.4.4 and changed download url to http://luarocks.github.io/luarocks/releases/luarocks-x.y.z.tar.gz
    - Added `--squash` to docker build
- 2018-10-04:
    - Updated OpenResty to 1.13.6.2 in Dockerfile
