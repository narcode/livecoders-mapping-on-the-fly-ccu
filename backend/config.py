import multiprocessing

workers = multiprocessing.cpu_count() * 2 + 1
bind = 'unix:aiohttp.sock'
umask = 0o007
reload = True
worker_class = 'aiohttp.GunicornWebWorker'

#logging
accesslog = '-'
errorlog = '-'