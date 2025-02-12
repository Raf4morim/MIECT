package com.example.touristGuide_app.Activities;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.InputType;
import android.text.TextUtils;
import android.view.MotionEvent;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.example.touristGuide_app.Model.User;
import com.example.touristGuide_app.R;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

import org.json.JSONException;
import org.json.JSONObject;

public class Login extends AppCompatActivity {
    String serverIp;
    User user;
    FirebaseAuth firebaseAuth;
    private EditText passwordEditText, mailEditText;
    private boolean isPasswordVisible = false;
    int userIdReq = 0;
    int calendarIdReq = 0;
    private static final int GOOGLE_LOGIN_REQUEST_CODE = 1001;

    @SuppressLint("ClickableViewAccessibility")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.login);
        serverIp = getString(R.string.ip);
        firebaseAuth = FirebaseAuth.getInstance();
        mailEditText = findViewById(R.id.mail);
        passwordEditText = findViewById(R.id.password);
        findViewById(R.id.loginbtn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Valide os campos de entrada
                if (validateFields()) {
                    String userMail = mailEditText.getText().toString();
                    String userPassword = passwordEditText.getText().toString();
                    // Crie um novo objeto User com as informações de entrada
                    user = new User();
                    user.setMail(userMail);
                    user.setPwd(userPassword);
                    // Verifique se o usuário já está autenticado
                    sendLoginRequest(userMail, userPassword);
                    // signupOrLogin(userMail, userPassword);
                }
            }
        });
        findViewById(R.id.btnGoogle).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Redirecionar para a página de login do Google
                String googleLoginUrl = "http://"+serverIp+"/login";
                Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(googleLoginUrl));
                startActivityForResult(intent, GOOGLE_LOGIN_REQUEST_CODE);
            }
        });
        // Configurar o clique no ícone do olho
        passwordEditText.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, R.drawable.baseline_remove_red_eye_24, 0);
        passwordEditText.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                final int DRAWABLE_RIGHT = 2;
                if (event.getAction() == MotionEvent.ACTION_UP) {
                    if (event.getRawX() >= (passwordEditText.getRight() - passwordEditText.getCompoundDrawables()[DRAWABLE_RIGHT].getBounds().width())) {
                        togglePasswordVisibility();
                        return true;
                    }
                }
                return false;
            }
        });
    }
    // Método para fazer login ou se inscrever
    private void signupOrLogin(String email, String password, int userIdReq, int calendarIdReq) {
        firebaseAuth.signInWithEmailAndPassword(email, password)
        .addOnCompleteListener(new OnCompleteListener<AuthResult>() {
            @Override
            public void onComplete(@NonNull Task<AuthResult> task) {
                if (task.isSuccessful()) {
                    // Login bem-sucedido, vá para a próxima tela (MainActivity)
                    FirebaseUser currentUser = firebaseAuth.getCurrentUser();
                    if (currentUser != null) {
                        openMainRoom(currentUser.getUid(), userIdReq, calendarIdReq);
                    }
                } else {
                    // Se o login falhar, tente criar uma nova conta
                    signup(email, password, userIdReq, calendarIdReq);
                }
            }
        });
    }
    // Método para criar uma nova conta
    private void signup(String email, String password, int userIdReq, int calendarIdReq) {
        firebaseAuth.createUserWithEmailAndPassword(email, password)
        .addOnCompleteListener(new OnCompleteListener<AuthResult>() {
            @Override
            public void onComplete(@NonNull Task<AuthResult> task) {
                if (task.isSuccessful()) {
                    // Registro bem-sucedido, vá para a próxima tela (MainActivity)
                    FirebaseUser newUser = task.getResult().getUser();
                    if (newUser != null) {
                        openMainRoom(newUser.getUid(), userIdReq, calendarIdReq);
                    }
                } else {
                    // Se o registro falhar, mostre uma mensagem de erro
                    Toast.makeText(Login.this, "Failed to sign up: " + task.getException().getMessage(), Toast.LENGTH_SHORT).show();
                }
            }
        });
    }
    private boolean validateFields() {
        String mail = mailEditText.getText().toString();
        String pwd = passwordEditText.getText().toString();
        if (TextUtils.isEmpty(mail)) {
            Toast.makeText(this, "Mail is missing!!", Toast.LENGTH_SHORT).show();
            return false;
        }
        if (TextUtils.isEmpty(pwd)) {
            Toast.makeText(this, "Password is missing!!", Toast.LENGTH_SHORT).show();
            return false;
        }
        return true;
    }
    // Método para alternar a visibilidade da senha
    private void togglePasswordVisibility() {
        if (isPasswordVisible) {
            passwordEditText.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
            isPasswordVisible = false;
        } else {
            passwordEditText.setInputType(InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
            isPasswordVisible = true;
        }
        passwordEditText.setSelection(passwordEditText.getText().length());
    }
//////////////////////////// GOOGLE ////////////////////////////
    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == GOOGLE_LOGIN_REQUEST_CODE && resultCode == RESULT_OK) {
            // Processar os dados retornados da autenticação do Google
            if (data != null) {
                String userId = data.getStringExtra("userId");
                openMainRoom(userId, userIdReq, calendarIdReq);
            }
        }
    }
    private void sendLoginRequest(String mail, String password) {
        // Construir o JSON com as credenciais
        JSONObject jsonBody = new JSONObject();
        try {
            jsonBody.put("email", mail);
            jsonBody.put("password", password);
        } catch (JSONException e) {
            Toast.makeText(Login.this, "Entrou aqui?", Toast.LENGTH_SHORT).show();
            e.printStackTrace();
        }
        // Enviar a solicitação POST para o servidor
        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.POST, "http://"+serverIp+"/login", jsonBody,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {
                        try {
                            // Processar a resposta do servidor
                            userIdReq = response.getInt("userId");
                            calendarIdReq = response.getInt("calendarId");
                            Toast.makeText(Login.this, "userId: "+userIdReq+"\ncalendarId: " + calendarIdReq, Toast.LENGTH_SHORT).show();
                            // Faça login no Firebase Authentication com as credenciais do usuário
                            signupOrLogin(mail, password, userIdReq, calendarIdReq);
                        } catch (JSONException e) {
                            Toast.makeText(Login.this, "Entrou aqui2?", Toast.LENGTH_SHORT).show();
                            e.printStackTrace();
                        }
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                // Tratar erros de resposta
                Toast.makeText(Login.this, "Erro no login: " + error.getMessage(), Toast.LENGTH_SHORT).show();
            }
        });
        // Adicionar a solicitação à fila de solicitações
        RequestQueueSingleton.getInstance(this).addToRequestQueue(jsonObjectRequest);
    }
    // Método para abrir a próxima página após o login bem-sucedido
    private void openMainRoom(String userId, int userIdReq, int calendarIdReq) {
        Intent intent = new Intent(this, ListOfPointOfInterest.class);
        intent.putExtra("userIdReq", userIdReq);
        intent.putExtra("calendarIdReq", calendarIdReq);
        Toast.makeText(this, "Enviou para MainActivity userId: "+userIdReq+" calendarId: " + calendarIdReq, Toast.LENGTH_SHORT).show();
        startActivity(intent);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        // Deslogar o usuário ao sair do aplicativo
        FirebaseAuth.getInstance().signOut();
    }
}