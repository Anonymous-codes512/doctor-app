"""create message and related tables

Revision ID: a4083fafd2a0
Revises: bd297c390edf
Create Date: 2025-07-01 12:15:20.724506

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'a4083fafd2a0'
down_revision = 'bd297c390edf'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('conversations',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('participant1_id', sa.Integer(), nullable=False),
    sa.Column('participant2_id', sa.Integer(), nullable=False),
    sa.Column('chat_secret', sa.String(length=500), nullable=False),
    sa.Column('created_at', sa.DateTime(), nullable=True),
    sa.ForeignKeyConstraint(['participant1_id'], ['users.id'], ),
    sa.ForeignKeyConstraint(['participant2_id'], ['users.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_table('messages',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('conversation_id', sa.Integer(), nullable=False),
    sa.Column('sender_id', sa.Integer(), nullable=False),
    sa.Column('receiver_id', sa.Integer(), nullable=False),
    sa.Column('encrypted_message', sa.Text(), nullable=False),
    sa.Column('message_type', sa.String(length=20), nullable=True),
    sa.Column('timestamp', sa.DateTime(), nullable=True),
    sa.Column('is_read', sa.Boolean(), nullable=True),
    sa.Column('read_at', sa.DateTime(), nullable=True),
    sa.ForeignKeyConstraint(['conversation_id'], ['conversations.id'], ),
    sa.ForeignKeyConstraint(['receiver_id'], ['users.id'], ),
    sa.ForeignKeyConstraint(['sender_id'], ['users.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('messages')
    op.drop_table('conversations')
    # ### end Alembic commands ###
