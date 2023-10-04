from . import db
from flask_login import UserMixin
from sqlalchemy.sql import func
from wtforms import StringField, TextAreaField
from flask_wtf import FlaskForm
from datetime import datetime
from itsdangerous import TimedJSONWebSignatureSerializer as Serializer
from flask import current_app
app=current_app
#Definir o meu user
class User(db.Model, UserMixin):
    
    id = db.Column(db.Integer, primary_key = True) #Isto garante-nos uma forma única de identificar cada user
    #Por exemplo, se 2 users tiverem o msm nome proprio, a key identifica qual é qual
    email = db.Column(db.String(150), unique = True)
    #Unique = true significa que nenhum user pode ter o mesmo email logo é invalido criar um user com o mm email
    full_name = db.Column(db.String(150))
    password = db.Column(db.String(150))

    def get_reset_token(self, expires_sec=1800):
        s = Serializer(app.config['SECRET_KEY'], expires_sec)
        return s.dumps({'user_id': self.id}).decode('utf-8')
    
    @staticmethod
    def verify_reset_token(token):
        s = Serializer(app.config['SECRET_KEY'])
        try:
            user_id = s.loads(token)['user_id']
        except:
            return None
        return User.query.get(user_id)

    

class Publication(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(30))
    description = db.Column(db.String(200))
    date=db.Column(db.DateTime(datetime.utcnow))
    replies = db.relationship('Reply', backref='publication', lazy='dynamic')
    def lastDate(self):
        lastReply = Reply.query.filter_by(publication_id=self.id).order_by(Reply.id.desc()).first()

        if lastReply:
            return lastReply.date

        return self.date

    
class Reply(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    publication_id = db.Column(db.Integer, db.ForeignKey('publication.id'))
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    user_name = db.Column(db.String(150))
    content = db.Column(db.String(200))
    date= db.Column(db.DateTime())

class NewPublication(FlaskForm):
    title = StringField('Title')
    description = StringField('Publication Text')

class NewReply(FlaskForm):
    content = TextAreaField('Content')
