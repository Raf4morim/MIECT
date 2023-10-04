from flask import Blueprint,render_template,request,flash,redirect,url_for
from .forms import PostForm,RequestResetForm,ResetPasswordForm
from .models import User
from . import db
from werkzeug.security import generate_password_hash, check_password_hash
from flask_login import login_user,login_required,logout_user,current_user
from .__init__ import Mail
from flask_mail import Message
from flask import current_app

auth = Blueprint('auth',__name__)

@auth.route ('/index',methods=['GET','POST'])
def index():
    return render_template("index.html",user=current_user)

@auth.route ('/login',methods=['GET','POST'])
def login():
    if request.method=='POST':
        email=request.form.get('email')
        password=request.form.get('password')
        if email=="" or password=="":
            flash('Invalid Credentials',category='error')
            return render_template("login.html", user=current_user)
        sql=f"SELECT * FROM User WHERE email='{email}' AND password='{password}'"
        
        user = User.query.from_statement(db.text(sql)).first()
        if user:
            flash('Logged in sucessfully!',category='sucess')
            login_user(user,remember=True)
            return redirect(url_for('views.home'))
        else:
            flash('Incorrect password,try again.',category='error')
    return render_template("login_healthclinic.html", user=current_user)


@auth.route ('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('auth.login'))

@auth.route ('/register',methods=['GET','POST'])
def register():
    
    if request.method=='POST':
            email=request.form.get('email')
            full_name=request.form.get('fullname')
            password=request.form.get('password')
            repassword=request.form.get('repassword')

            user=User.query.filter_by(email=email).first()

            if user:
                flash('Email already exists.',category='error')
            elif len(email) < 4:
                flash('Email must be greater than 3 characters.', category='error')
            elif len(full_name) < 2:
                flash('First name must be greater than 1 character.', category='error')
            elif password != repassword:
                flash('Passwords don\'t match.', category='error')
            elif len(password) < 7:
                flash('Password must be at least 7 characters.', category='error')
            else:
                if email.find('/'): email.replace('/','\'')
                if email.find('-'): email.replace('-','\-')
                if email.find('"'): email.replace('-','\"')
                if full_name.find('/'): full_name.replace('/','\'')
                if full_name.find('-'): full_name.replace('-','\-')
                if full_name.find('"'): full_name.replace('-','\"')
                if password.find('/'): password.replace('/','\'')
                if password.find('-'): password.replace('-','\-')
                if password.find('"'): password.replace('-','\"')
                new_user = User(email=email,full_name=full_name,password=password)
                db.session.add(new_user)
                db.session.commit()
                login_user(new_user,remember=True)
                flash('Account created!',category='success')
                return redirect(url_for('views.home'))

    return render_template("register_healthclinic.html",user=current_user)

@auth.route ('/profile/<userid>',methods=['GET','POST'])
@login_required
def profile(userid):
    userr=User.query.get(int(userid))
    return render_template("Pessoa.html",user=userr)

@auth.route ('/funcionario2',methods=['GET','POST'])
@login_required
def funcionario2():
    if current_user.is_authenticated:
        return render_template("funcionario2.html", user=current_user)


@auth.route ('/resetpassword',methods=['GET','POST'])
def reset_password():
    if current_user.is_authenticated:
        return redirect(url_for('views.home'))
    form = ResetPasswordForm()
    user = User.query.filter_by(email=form.email.data).first()
    if user:
        if form.validate_on_submit():
            password=request.form.get('password')
            if password.find('/'): password.replace('/','\'')
            if password.find('-'): password.replace('-','\-')
            if password.find('"'): password.replace('-','\"')
            
            user.password = password
            db.session.commit()
            flash('Your password has been updated! You are now able to log in',category='success')
            return redirect(url_for('auth.login'))
    else:
        return render_template('reset_token.html',title='Reset Password',form=form,user=current_user)

@auth.route('/download')
def download():
    path = 'samplefile.pdf'
    return send_file(path, as_attachment=True)