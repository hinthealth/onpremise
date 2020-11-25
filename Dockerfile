FROM getsentry/sentry:34c6f3d

COPY . /usr/src/sentry

# Hook for installing additional plugins
RUN if [ -s /usr/src/sentry/requirements.txt ]; then pip install -r /usr/src/sentry/requirements.txt; fi

RUN PSYCOPG=$(pip freeze | grep psycopg2) \
	&& pip uninstall -y $PSYCOPG \
	&& pip install --no-binary :all: $PSYCOPG
