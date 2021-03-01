#!/usr/bin/env python3

import string
import random
import hashlib
from aiomysql.sa import create_engine
from aiohttp import web
from aiohttp_middlewares import cors_middleware
from aiohttp_middlewares.cors import DEFAULT_ALLOW_HEADERS
import db as engine 

routes = web.RouteTableDef()



@routes.post('/save')
async def saveProgress(request):
    payload = await request.read()
    json = await request.json()
    rand = random.sample(list(string.ascii_letters + string.digits), 15)
    form_id = ''.join(rand) + hashlib.sha1(payload).hexdigest()
    db = request.config_dict['DB']
    print(json)
    async with db.acquire() as conn:
        trans = await conn.begin()
        try:
            res = await conn.execute(engine.tbl.insert().values(form_id=form_id, 
                                                            branch=json['branch'],
                                                            responses=json['answers'],
                                                            checkboxes=json['checkboxes'],
                                                            submitted=json['submitted']
                                                            ))
        except Exception as e:
            print(e)
            await trans.rollback()
        else:
            await trans.commit()
            
    data = {"id": res.lastrowid, 'formid': form_id, 'submitted': row.submitted}
    return web.json_response(data)


@routes.post('/update')
async def updateProgress(request):
    json = await request.json()
    db = request.config_dict['DB']
    print(json)
    async with db.acquire() as conn:
        trans = await conn.begin()
        try:
            res = await conn.execute(engine.tbl.update()
                                     .where(engine.tbl.c.id==json['id'])
                                     .values(responses=json['answers'],
                                             checkboxes=json['checkboxes'],
                                             submitted=json['submitted'])
                                     
                                     )          
        except Exception as e:
            print(e)
            await trans.rollback()
        else:
            await trans.commit()
        
        get = await conn.execute(engine.tbl.select().where(engine.tbl.c.id==json['id']))
        row = await get.first()          
            
            
    data = {"id": row.id, 'formid': row.form_id, 'submitted': row.submitted}
    return web.json_response(data)


@routes.post('/load')
async def loadProgress(request):
    json = await request.json()
    form_id = json['formid']
    db = request.config_dict['DB']
    print(json)
    async with db.acquire() as conn:
        try:
            res = await conn.execute(engine.tbl.select().where(engine.tbl.c.form_id==form_id))
            row = await res.first()
        except Exception as e:
            print(e)
    print(row)
    answers = {"answers": row.responses, "checkboxes": {}}
    data = {"id": row.id, "answers": answers, "branch": row.branch, "submitted": row.submitted}
    return web.json_response(data)


async def init_db(app: web.Application):
    db = await create_engine(host='127.0.0.1', port=3306,
                                       user='onthefly', password='onthefly2020',
                                       db='onthefly_mapping')
    app['DB'] = db

async def close_db(app: web.Application):
    app['DB'].close()
    await app['DB'].wait_closed()
     

app = web.Application(
    middlewares=[cors_middleware(origins=["http://localhost:3000"])]
)

app.add_routes(routes)
app.on_startup.append(init_db)
app.on_cleanup.append(close_db)
# web.run_app(app)