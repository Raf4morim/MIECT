using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.UI.WebControls.WebParts;
using System.Windows.Forms;
using System.Xml.Linq;

namespace proj1
{
    public partial class AddProjeto : Form
    {
        private SqlConnection cn;
        public AddProjeto()
        {
            InitializeComponent();
        }

        private void AddProjeto_Load(object sender, EventArgs e)
        {
            cn = getSGBDConnection();
            PopulateNIFDropdown();
        }

        private void PopulateNIFDropdown()
        {
            string query = "SELECT FK_NIF FROM Cliente";

            SqlCommand command = new SqlCommand(query, cn);
            cn.Open();
            SqlDataReader reader = command.ExecuteReader();

            while (reader.Read())
            {
                string nif = reader["FK_NIF"].ToString();
                comboBox1.Items.Add(nif);
            }

            reader.Close();
        }
        private SqlConnection getSGBDConnection()
        {
            string dbServer = "tcp:mednat.ieeta.pt\\SQLSERVER,8101";
            string dbName = "p7g5";
            string userName = "p7g5";
            string userPass = "228961584@BD!";
            return new SqlConnection("Data Source = " + dbServer + " ;" + "Initial Catalog = " + dbName + "; uid = " + userName + ";" + "password = " + userPass);
        }

        private void textIdentificacao_TextChanged(object sender, EventArgs e)
        {

        }
        private void textBoxNIFCliente_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBoxNjanelas_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBoxNportas_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBoxNportadas_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBoxDuracao_TextChanged(object sender, EventArgs e)
        {

        }

        private void BtnEnviar_Click(object sender, EventArgs e)
        {
            try
            {
                string id = textIdentificacao.Text;
                string nJanelas = textBoxNjanelas.Text;
                string nPortas = textBoxNportas.Text;
                string nPortadas = textBoxNportadas.Text;
                string duracao = textBoxDuracao.Text;
                string dataChegada = textBoxChegada.Text;
                string nifCliente = comboBox1.SelectedItem as string;
                
                DateTime parsedDataConclusao;
                if (!DateTime.TryParse(textBoxChegada.Text, out parsedDataConclusao))
                {
                    MessageBox.Show("Data de chegada inválida. Certifique-se de que está no formato correto (ex: dd-mm-yyyy).", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                if (string.IsNullOrEmpty(id) || string.IsNullOrEmpty(nJanelas) || string.IsNullOrEmpty(nPortas) ||
                    string.IsNullOrEmpty(nPortadas) || string.IsNullOrEmpty(duracao) || string.IsNullOrEmpty(dataChegada) ||
                    string.IsNullOrEmpty(nifCliente))
                {
                MessageBox.Show("Por favor, preencha todos os campos!", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                int parsedID;
                if (!int.TryParse(id, out parsedID))
                {
                MessageBox.Show("ID do projeto deve ser um número inteiro!", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                int parsedNJanelas;
                if (!int.TryParse(nJanelas, out parsedNJanelas))
                {
                MessageBox.Show("Número de janelas deve ser um número inteiro!", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                int parsedNPortas;
                if (!int.TryParse(nPortas, out parsedNPortas))
                {
                MessageBox.Show("Número de portas deve ser um número inteiro!", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                int parsedNPortadas;
                if (!int.TryParse(nPortadas, out parsedNPortadas))
                {
                MessageBox.Show("Número de portadas deve ser um número inteiro!", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                int parsedDuracao;
                if (!int.TryParse(duracao, out parsedDuracao))
                {
                MessageBox.Show("Duração deve ser um número inteiro!", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

         

                string query = "INSERT INTO projeto(ID, N_Janelas, N_Portas, N_Portadas, Duracao, Data_conclusao, FK_NIF_Cliente) " +
                               "VALUES (@ID, @NJanelas, @NPortas, @NPortadas, @Duracao, @DataConclusao, @NIFCliente)";

                SqlCommand command = new SqlCommand(query, cn);
                command.Parameters.AddWithValue("@ID", id);
                command.Parameters.AddWithValue("@NJanelas", nJanelas);
                command.Parameters.AddWithValue("@NPortas", nPortas);
                command.Parameters.AddWithValue("@NPortadas", nPortadas);
                command.Parameters.AddWithValue("@Duracao", duracao);
                command.Parameters.AddWithValue("@DataConclusao", dataChegada);
                command.Parameters.AddWithValue("@NIFCliente", nifCliente);

                int rowsAffected = command.ExecuteNonQuery();
                cn.Close();

                if (rowsAffected > 0)
                {
                    // Insert successful
                    MessageBox.Show("Projeto adicionado com sucesso.");
                }
                else
                {
                    // Insert failed
                MessageBox.Show("Erro ao adicionar projeto!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }

                this.Close();
                projetoCliente projetoCliente = new projetoCliente();

                projetoCliente.Show();
            }
            catch (Exception ex)
            {
                if (ex.Message.Contains("A data de conclusão do projeto não pode ser menor que a duração do mesmo"))
                {
                MessageBox.Show("A data de conclusão do projeto não pode ser menor que a duração do mesmo.");
                }
                else
                {

                    MessageBox.Show("Ocorreu um erro: " + ex.Message);
                }
            }
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void pictureBox2_Click(object sender, EventArgs e)
        {
            this.Close();
            AddRmv AddRmv = new AddRmv();
            AddRmv.Show();
        }

        private void textBoxDataConclusao_ValueChanged(object sender, EventArgs e)
        {

        }

        private void BtnLimpar_Click(object sender, EventArgs e)
        {
            textIdentificacao.Text = "";
            textBoxNjanelas.Text = "";
            textBoxNportas.Text = "";
            textBoxNportadas.Text = "";
            textBoxDuracao.Text = "";
            textBoxChegada.Text = "";
            comboBox1.SelectedItem = null;
        }
    }
}