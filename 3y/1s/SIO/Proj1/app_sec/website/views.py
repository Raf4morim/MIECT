from threading import ThreadError
from flask import Blueprint, render_template, request, flash, redirect, url_for
from flask_login import login_required, logout_user,current_user
from werkzeug import datastructures
from . import db
from sqlalchemy.sql import func
from .models import Publication,NewPublication,NewReply,Reply
from datetime import datetime
import time

views = Blueprint('views',__name__)

@views.route('/', methods=['GET', 'POST'])

@login_required
def home():
    form = NewPublication()
    db.create_all()
    if form.validate_on_submit():
        time.sleep(10)
        newPub = Publication(title=form.title.data, description=form.description.data,date=datetime.now())
        db.session.add(newPub)
        db.session.commit()
    db.create_all()
    pubs = Publication.query.all()

    return render_template('home.html', form=form, publications=pubs, user=current_user)


@views.route('/publication/<publication_id>', methods=['GET', 'POST'])

@login_required

def publication(publication_id):

    form = NewReply()

    pub = Publication.query.get(int(publication_id))
    
    if form.validate_on_submit():
        if not current_user.is_authenticated:
            flash('You must be logged in to reply')
            return redirect(url_for('views.publication', publication_id=publication_id))
        else:
            if form.content.data=="":
                flash('Need to write something',category='error')
                replies = Reply.query.filter_by(publication_id=publication_id).all()
                return render_template('publication.html', publication=pub, form=form, replies=replies, user=current_user)
            reply = Reply(user_id=current_user.id, content=form.content.data, date=datetime.now())
            pub.replies.append(reply)
            db.session.commit()
    replies = Reply.query.filter_by(publication_id=publication_id).all()

    return render_template('publication.html', publication=pub, form=form, replies=replies, user=current_user)

@views.route('/search', methods=['GET', 'POST'])
@login_required
def searchpublication():
    if request.method=="GET":
        q=request.args.get('q')
        if q:
            post=Publication.query.filter(Publication.title.contains(q)) or Publication.query.filter(Publication.description.contains(q))
        else:
            post=Publication.query.all()
    return render_template('search.html',publications=post,user=current_user)
