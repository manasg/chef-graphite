default['graphite']['version'] = "0.9.10"

# used for .htpasswd
default['graphite_web']['user'] = "graphite"
default['graphite_web']['password'] = "graphite"
# I know I know!
default['graphite_web']['password_htpasswd'] = "$apr1$5f.70MUr$m6mitl6hKzW8NLLju.Sl20"

# This is accomplished by copying sqlite DB.. once again.. I know its non-optimal
default['graphite']['account1']['user'] = "graphite_user"
default['graphite']['account1']['password'] = "graphite_user"

default['graphite']['packages'] = %w[ python-cairo python-django python-django-tagging python-twisted python-zope.interface fontconfig apache2 libapache2-mod-wsgi python-pysqlite2 python-simplejson git-core ]

# this is where the code is checked out.
default['graphite']['src_dir'] = "/graphite_src"
default['graphite']['src']['carbon'] = 'https://github.com/graphite-project/carbon.git'
default['graphite']['src']['whisper'] = 'https://github.com/graphite-project/whisper.git'
default['graphite']['src']['graphite_web'] = 'https://github.com/graphite-project/graphite-web.git'

default['graphite']['carbon_user'] = "carbon"
