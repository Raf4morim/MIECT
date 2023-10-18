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
    public partial class AddFuncionario : Form
    {
        private SqlConnection cn;
        public AddFuncionario()
        {
            InitializeComponent();
        }
        private void AddFuncionario_Load(object sender, EventArgs e)
        {
            cn = getSGBDConnection();
        }
        private SqlConnection getSGBDConnection()
        {
            string dbServer = "tcp:mednat.ieeta.pt\\SQLSERVER,8101";
            string dbName = "p7g5";
            string userName = "p7g5";
            string userPass = "228961584@BD!";
            return new SqlConnection("Data Source = " + dbServer + " ;" + "Initial Catalog = " + dbName + "; uid = " + userName + ";" + "password = " + userPass);

        }
        private void BtnEnviar_Click(object sender, EventArgs e)
        {
            try
            {
                cn.Open();

                string Name = textBoxName.Text;
                string CC = textBoxCC.Text;
                string NIF = textBoxNIF.Text;
                string Contact = textBoxContact.Text;
                string Mail = textBoxMail.Text;
                string Idade = textBoxLocalidade.Text;
                string Ordenado = textBoxDist.Text;
                string Seguro = textBox1.Text;

                if (string.IsNullOrEmpty(Name) || string.IsNullOrEmpty(CC) || string.IsNullOrEmpty(NIF) ||
                    string.IsNullOrEmpty(Contact) || string.IsNullOrEmpty(Mail) || string.IsNullOrEmpty(Idade) ||
                    string.IsNullOrEmpty(Ordenado) || string.IsNullOrEmpty(Seguro))
                {
                    MessageBox.Show("Por favor preencha todos os campos.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                string parsedName;
                if (string.IsNullOrEmpty(Name))
                {
                    MessageBox.Show("Nome inválido.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
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

                int parsedIdade;
                if (!int.TryParse(Idade, out parsedIdade))
                {
                    MessageBox.Show("Idade inválida.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                float parsedOrdenado;
                if (!float.TryParse(Ordenado, out parsedOrdenado))
                {
                    MessageBox.Show("Ordenado inválido. Introduza um valor real ou inteiro.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                string parsedSeguro;
                if (string.IsNullOrEmpty(Seguro))
                {
                    MessageBox.Show("Seguro inválido. Introduza 'Sim' ou 'Não'.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }
                parsedSeguro = Seguro;

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

                if (parsedIdade < 17)
                {
                    MessageBox.Show("A idade deve ser igual ou superior a 17 anos.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                if (parsedOrdenado <= 740.83)
                {
                    MessageBox.Show("O ordenado deve ser superior a 740.83 euros.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                if (!(Seguro.Equals("Sim") || Seguro.Equals("Não"))) 
                {
                    MessageBox.Show("Seguro inválido. Certifique-se de que escreveu 'Sim' ou 'Não'.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                SqlCommand command = new SqlCommand("sp_add_funcionario", cn);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@Mail", Mail);
                command.Parameters.AddWithValue("@CC", CC);
                command.Parameters.AddWithValue("@Nome", Name);
                command.Parameters.AddWithValue("@Telemovel", Contact);
                command.Parameters.AddWithValue("@NIF", NIF);
                command.Parameters.AddWithValue("@Idade", Idade);
                command.Parameters.AddWithValue("@Ordenado", Ordenado);
                command.Parameters.AddWithValue("@Seguro", Seguro);

                int rowsAffected = command.ExecuteNonQuery();

                if (rowsAffected > 0)
                {
                    MessageBox.Show("Funcionário adicionado com sucesso.");

                }
                else
                {
                MessageBox.Show("Erro ao adicionar funcionário!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
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

        private void pictureBox2_Click(object sender, EventArgs e)
        {
            this.Close();
            AddRmv AddRmv = new AddRmv();
            AddRmv.Show();
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
            textBox1.Text = "";
        }

        private void textBoxName_TextChanged(object sender, EventArgs e)
        {

        }
    }
}
