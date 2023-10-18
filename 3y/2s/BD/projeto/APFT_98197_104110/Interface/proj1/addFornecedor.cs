using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace proj1
{
    public partial class addFornecedor : Form
    {
        private SqlConnection cn;

        public addFornecedor()
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

        private void btnEnviar_Click(object sender, EventArgs e)
        {
            cn = getSGBDConnection();
            try
            {
                cn.Open();

                string Name = textBoxName.Text;
                string IBAN = textBoxIBAN.Text;
                string NIF = textBoxNIF.Text;
                string Localidade = textBoxLocalidade.Text;
                string Dist = textBoxDist.Text;
                string Telefone = textBoxTelefone.Text;

                if (string.IsNullOrEmpty(Name) || string.IsNullOrEmpty(IBAN) || string.IsNullOrEmpty(NIF) || string.IsNullOrEmpty(Telefone) ||
                    string.IsNullOrEmpty(Localidade) ||
                    string.IsNullOrEmpty(Dist))
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

                int parsedNIF;
                if (!int.TryParse(NIF, out parsedNIF))
                {
                    MessageBox.Show("NIF inválido. Certifique-se de que o NIF contém apenas dígitos numéricos.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                int parsedTelefone;
                if (!int.TryParse(Telefone, out parsedTelefone))
                {
                    MessageBox.Show("Telefone inválido. Certifique-se de que o Telefone contém apenas dígitos numéricos.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

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
                    MessageBox.Show("Distância inválido. Certifique-se de que o distância é um valor numérico.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                if (!IBAN.StartsWith("PT50") || IBAN.Length != 25 || !Regex.IsMatch(IBAN.Substring(4), "^[0-9]{21}$"))
                {
                    MessageBox.Show("IBAN inválido. Certifique-se de que o IBAN começa com 'PT50' seguido por 21 dígitos numéricos.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                if (NIF.Length != 9)
                {
                    MessageBox.Show("NIF inválido. Certifique-se de que o NIF contém 9 dígitos numéricos.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                if (Telefone.Length != 9)
                {
                    MessageBox.Show("Telefone inválido. Certifique-se de que o Telefone contém 9 dígitos numéricos.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                if (parsedLocalidade.Length > 20)
                {
                    MessageBox.Show("Localidade inválida. Certifique-se de que a localidade não excede 20 caracteres.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                // Insere o registro na tabela 'cliente' usando o valor do 'NIF' gerado na inserção anterior
                string queryFornecedor = "INSERT INTO fornecedor(NIF, Nome, IBAN, Localizacao, Distancia, Telefone) VALUES (@NIF, @Nome, @IBAN, @Localidade, @Distancia, @Telefone)";
                SqlCommand commandFornecedor = new SqlCommand(queryFornecedor, cn);
                commandFornecedor.Parameters.AddWithValue("@NIF", NIF);
                commandFornecedor.Parameters.AddWithValue("@Nome", Name);
                commandFornecedor.Parameters.AddWithValue("@IBAN", IBAN);
                commandFornecedor.Parameters.AddWithValue("@Localidade", Localidade);
                commandFornecedor.Parameters.AddWithValue("@Distancia", Dist);
                commandFornecedor.Parameters.AddWithValue("@Telefone", Telefone);

                int rowsAffectedFornecedor = commandFornecedor.ExecuteNonQuery();

                if (rowsAffectedFornecedor > 0)
                {
                    // Ambas as inserções foram bem-sucedidas
                    MessageBox.Show("Fornecedor adicionado com sucesso.");
                }
                else
                {
                    // A inserção na tabela 'cliente' falhou
                    MessageBox.Show("Erro ao adicionar Fornecedor.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
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
            textBoxIBAN.Text = "";
            textBoxNIF.Text = "";
            textBoxLocalidade.Text = "";
            textBoxDist.Text = "";
            textBoxTelefone.Text = "";
        }

        private void pictureBox2_Click(object sender, EventArgs e)
        {
            this.Close();
            AddRmv AddRmv = new AddRmv();
            AddRmv.Show();
        }
    }
}
