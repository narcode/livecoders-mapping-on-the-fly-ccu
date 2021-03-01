import sqlalchemy as sa 

metadata = sa.MetaData()

tbl = sa.Table('responses', metadata,
               sa.Column('id', sa.Integer, primary_key=True),
               sa.Column('form_id', sa.String(255)),
               sa.Column('branch', sa.String(255)),
               sa.Column('responses', sa.JSON),
               sa.Column('checkboxes', sa.JSON),
               sa.Column('submitted', sa.Boolean)
               )
               