ARG ODOO_VERSION=19.0
FROM odoo:${ODOO_VERSION}

USER root

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        git \
        curl; \
    rm -rf /var/lib/apt/lists/*

COPY addons/customs/requirements.txt /tmp/requirements-customs.txt
COPY addons/ocas/requirements.txt /tmp/requirements-ocas.txt

RUN set -eux; \
    if grep -qvE '^\s*(#|$)' /tmp/requirements-customs.txt /tmp/requirements-ocas.txt; then \
        PIP_BREAK_SYSTEM_PACKAGES=1 pip3 install --no-cache-dir \
            -r /tmp/requirements-customs.txt \
            -r /tmp/requirements-ocas.txt; \
    fi

RUN mkdir -p /var/log/odoo && chown -R odoo:odoo /var/log/odoo
