#!/usr/bin/env python3

import string
import random
import hashlib
import aiohttp
from aiohttp import web
from aiohttp_middlewares import cors_middleware
from aiohttp_middlewares.cors import DEFAULT_ALLOW_HEADERS

routes = web.RouteTableDef()

@routes.post('/save')
async def saveProgress(request):
    payload = await request.read()
    rand = random.sample(list(string.ascii_letters + string.digits + "!#$%()*" ), 15)
    form_id = ''.join(rand) + hashlib.sha1(payload).hexdigest()
    data = {"id": 1, 'formid': form_id, 'submitted': False}
    return web.json_response(data)

app = web.Application(
    middlewares=[cors_middleware(origins=["http://localhost:3000"])]
)
app.add_routes(routes)
web.run_app(app)