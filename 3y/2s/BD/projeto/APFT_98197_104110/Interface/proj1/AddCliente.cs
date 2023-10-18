using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace proj1
{
    public partial class AddCliente : Form
    {
        private SqlConnection cn;

        public AddCliente()
        {
            InitializeComponent();
        }

        private SqlConnection getSGBDConnection()
        {
            string dbServer = "tcp:mednat.ieeta.pt\\SQLSERVER,8101";
            string dbName = "p7g5";
            string userName = "p7g5";
            string userPass = "228961584@BD!";
            return new SqlConnection("Data Source = " + dbServer + " ;" + "Initial Catalog = " + dbName + "; uid = " + userName + ";" + "password = " + userPass);
        }

        private void btnCliente_Click(object sender, EventArgs e)
        {
            cn = getSGBDConnection();
            try
            {
                cn.Open();

                string Name = textBoxName.Text;
                string CC = textBoxCC.Text;
                string NIF = textBoxNIF.Text;
                string Contact = textBoxContact.Text;
                string Mail = textBoxMail.Text;
                string Localidade = textBoxLocalidade.Text;
                string Dist = textBoxDist.Text;

                if (string.IsNullOrEmpty(Name) || string.IsNullOrEmpty(CC) || string.IsNullOrEmpty(NIF) ||
                    string.IsNullOrEmpty(Contact) || string.IsNullOrEmpty(Mail) || string.IsNullOrEmpty(Localidade) ||
                    string.IsNullOrEmpty(Dist))
                {
                    MessageBox.Show("Por favor preencha todos os campos.");
                    return;
                }

                string parsedName;
                if (string.IsNullOrEmpty(Name))
                {
                    MessageBox.Show("Nome inválido.");
                    return;
                }
                parsedName = Name;

                int parsedCC;
                if (!int.TryParse(CC, out parsedCC))
                {
                    MessageBox.Show("CC inválido. Certifique-se de que o CC contém apenas dígitos numéricos.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                int parsedNIF;
                if (!int.TryParse(NIF, out parsedNIF))
                {
                    MessageBox.Show("NIF inválido. Certifique-se de que o NIF contém apenas dígitos numéricos.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                int parsedContact;
                if (!int.TryParse(Contact, out parsedContact))
                {
                    MessageBox.Show("Contacto inválido. Certifique-se de que o contacto contém apenas dígitos numéricos.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                string parsedMail;
                if (string.IsNullOrEmpty(Mail))
                {
                    MessageBox.Show("Email inválido.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }
                parsedMail = Mail;

                string parsedLocalidade;
                if (string.IsNullOrEmpty(Localidade))
                {
                    MessageBox.Show("Localidade inválida.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }
                parsedLocalidade = Localidade;

                int parsedDist;
                if (!int.TryParse(Dist, out parsedDist))
                {
                    MessageBox.Show("Distrito inválido. Certifique-se de que o distrito é um valor numérico.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                // Avisos (warnings) para os checks das tabelas
                if (!parsedMail.Contains("@") || !parsedMail.Contains("."))
                {
                    MessageBox.Show("Email inválido. Certifique-se de que o email contém um '@' e um '.'", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                if (CC.Length != 8)
                {
                    MessageBox.Show("CC inválido. Certifique-se de que o CC contém 8 dígitos numéricos.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                if (NIF.Length != 9)
                {
                    MessageBox.Show("NIF inválido. Certifique-se de que o NIF contém 9 dígitos numéricos.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                if (Contact.Length != 9)
                {
                    MessageBox.Show("Contacto inválido. Certifique-se de que o contacto contém 9 dígitos numéricos.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                if (parsedLocalidade.Length > 20)
                {
                    MessageBox.Show("Localidade inválida. Certifique-se de que a localidade não excede 20 caracteres.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                SqlCommand command = new SqlCommand("sp_add_cliente", cn);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@Mail", Mail);
                command.Parameters.AddWithValue("@CC", CC);
                command.Parameters.AddWithValue("@Nome", Name);
                command.Parameters.AddWithValue("@Telemovel", Contact);
                command.Parameters.AddWithValue("@NIF", NIF);
                command.Parameters.AddWithValue("@Localizacao", Localidade);
                command.Parameters.AddWithValue("@Distancia", Dist);

                int rowsAffected = command.ExecuteNonQuery();

                if (rowsAffected > 0)
                {
                    MessageBox.Show("Cliente adicionado com sucesso.");
                }
                else
                {
                    MessageBox.Show("Erro ao adicionar cliente.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error: {ex.Message}");
            }
            finally
            {
                cn.Close();
            }
        }

        private void BtnLimpar_Click(object sender, EventArgs e)
        {
            textBoxName.Text = "";
            textBoxCC.Text = "";
            textBoxNIF.Text = "";
            textBoxContact.Text = "";
            textBoxMail.Text = "";
            textBoxLocalidade.Text = "";
            textBoxDist.Text = "";
        }

        private void AddCliente_Load(object sender, EventArgs e)
        {
        }

        private void pictureBox2_Click(object sender, EventArgs e)
        {
            this.Close();
            AddRmv AddRmv = new AddRmv();

            // Display Form1
            AddRmv.Show();
        }
    }
}
