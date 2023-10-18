using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace proj1
{
    public partial class EditarProj : Form
    {
        private SqlConnection cn;
        public EditarProj()
        {
            InitializeComponent();
        }

        private void EditarProj_Load(object sender, EventArgs e)
        {
            cn = getSGBDConnection();
            PopulateNIFDropdown();
        }

        private void PopulateNIFDropdown()
        {
            // Limpar itens anteriores no comboBoxRef
            
            string queryNIF = "SELECT FK_NIF FROM Cliente";
            string queryID = "SELECT ID FROM projeto";
            SqlCommand commandNIF = new SqlCommand(queryNIF, cn);
            SqlCommand commandID = new SqlCommand(queryID, cn);
            // Obter o ID selecionado na ComboIdentificacao
            
            cn.Open();


            SqlDataReader readerNIF = commandNIF.ExecuteReader();

            while (readerNIF.Read())
            {
                string nif = readerNIF["FK_NIF"].ToString();
                comboNIF.Items.Add(nif);
            }

            readerNIF.Close();

            SqlDataReader readerID = commandID.ExecuteReader();

            while (readerID.Read())
            {
                string ID = readerID["ID"].ToString();
                ComboIdentificacao.Items.Add(ID);
            }

            readerID.Close();
        }
        private SqlConnection getSGBDConnection()
        {
            string dbServer = "tcp:mednat.ieeta.pt\\SQLSERVER,8101";
            string dbName = "p7g5";
            string userName = "p7g5";
            string userPass = "228961584@BD!";
            return new SqlConnection("Data Source = " + dbServer + " ;" + "Initial Catalog = " + dbName + "; uid = " + userName + ";" + "password = " + userPass);

        }
        private bool verifySGBDConnection()
        {
            if (cn == null)
                cn = getSGBDConnection();

            if (cn.State != ConnectionState.Open)
                cn.Open();

            return cn.State == ConnectionState.Open;
        }


        private void pictureBox2_Click(object sender, EventArgs e)
        {
            this.Close();
            AddRmv AddRmv = new AddRmv();

            // Display Form1
            AddRmv.Show();
        }

        private void comboBoxRef_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void BtnEnviar_Click(object sender, EventArgs e)
        {
            try
            {
                string id = ComboIdentificacao.Text;
                string nJanelas = textBoxNjanelas.Text;
                string nPortas = textBoxNportas.Text;
                string nPortadas = textBoxNportadas.Text;
                string duracao = textBoxDuracao.Text;
                string dataConclusao = textBoxConclusao.Text;
                string nifCliente = comboNIF.SelectedItem as string;
                string material = textBoxRef.Text;
                string unidades = textBoxUnidades.Text;

                if (string.IsNullOrEmpty(id) || (string.IsNullOrEmpty(nJanelas) && string.IsNullOrEmpty(nPortas) &&
                    string.IsNullOrEmpty(nPortadas) && string.IsNullOrEmpty(duracao) && string.IsNullOrEmpty(dataConclusao) &&
                    string.IsNullOrEmpty(nifCliente) && string.IsNullOrEmpty(material) && string.IsNullOrEmpty(unidades)))
                {
                    MessageBox.Show("Preencha o campo ID e pelo menos um dos outros campos!", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                // Verificar se o material existe na tabela de materiais
                string queryVerificarMaterial = "SELECT N_Referencia_Material FROM material WHERE N_Referencia_Material = @material";

                using (SqlCommand commandVerificarMaterial = new SqlCommand(queryVerificarMaterial, cn))
                {
                    commandVerificarMaterial.Parameters.AddWithValue("@material", material);

                    using (SqlDataReader reader = commandVerificarMaterial.ExecuteReader())
                    {
                        if (!reader.HasRows && !string.IsNullOrEmpty(material))
                        {
                            MessageBox.Show("O material informado não existe na tabela de materiais.", "Aviso", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            return;
                        }
                    }
                }

                DateTime parsedDataConclusao;
                if (!string.IsNullOrEmpty(dataConclusao) && !DateTime.TryParse(textBoxConclusao.Text, out parsedDataConclusao))
                {
                    MessageBox.Show("Data de chegada inválida. Certifique-se de que está no formato correto (ex: dd-mm-yyyy).", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                int parsedID;
                if (!string.IsNullOrEmpty(id) && !int.TryParse(id, out parsedID))
                {
                    MessageBox.Show("ID do projeto deve ser um número inteiro!", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                int parsedNJanelas;
                if (!string.IsNullOrEmpty(nJanelas) && !int.TryParse(nJanelas, out parsedNJanelas))
                {
                    MessageBox.Show("Número de janelas deve ser um número inteiro!", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                int parsedNPortas;
                if (!string.IsNullOrEmpty(nPortas) && !int.TryParse(nPortas, out parsedNPortas))
                {
                    MessageBox.Show("Número de portas deve ser um número inteiro!", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                int parsedNPortadas;
                if (!string.IsNullOrEmpty(nPortadas) && !int.TryParse(nPortadas, out parsedNPortadas))
                {
                    MessageBox.Show("Número de portadas deve ser um número inteiro!", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                int parsedDuracao;
                if (!string.IsNullOrEmpty(duracao) && !int.TryParse(duracao, out parsedDuracao))
                {
                    MessageBox.Show("Duração deve ser um número inteiro!", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                int parsedUnidades;
                if (!string.IsNullOrEmpty(unidades) && !int.TryParse(unidades, out parsedUnidades))
                {
                    MessageBox.Show("Unidades devem ser um número inteiro!", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }



                if ( string.IsNullOrEmpty(material) && !string.IsNullOrEmpty(unidades))
                {
                    MessageBox.Show("Informe as unidades correspondentes ao material.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }
                if (string.IsNullOrEmpty(unidades) && !string.IsNullOrEmpty(material))
                {
                    MessageBox.Show("Informe as unidades correspondentes ao material.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                string query = "sp_update_projeto";

                using (SqlCommand command = new SqlCommand(query, cn))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@id", id);
                    command.Parameters.AddWithValue("@nJanelas", string.IsNullOrEmpty(nJanelas) ? (object)DBNull.Value : int.Parse(nJanelas));
                    command.Parameters.AddWithValue("@nPortas", string.IsNullOrEmpty(nPortas) ? (object)DBNull.Value : int.Parse(nPortas));
                    command.Parameters.AddWithValue("@nPortadas", string.IsNullOrEmpty(nPortadas) ? (object)DBNull.Value : int.Parse(nPortadas));
                    command.Parameters.AddWithValue("@duracao", string.IsNullOrEmpty(duracao) ? (object)DBNull.Value : int.Parse(duracao));
                    command.Parameters.AddWithValue("@dataConclusao", string.IsNullOrEmpty(dataConclusao) ? (object)DBNull.Value : DateTime.Parse(dataConclusao));
                    command.Parameters.AddWithValue("@nifCliente", string.IsNullOrEmpty(nifCliente) ? (object)DBNull.Value : int.Parse(nifCliente));
                    command.Parameters.AddWithValue("@material", string.IsNullOrEmpty(material) ? (object)DBNull.Value : material);
                    command.Parameters.AddWithValue("@unidades", string.IsNullOrEmpty(unidades) ? (object)DBNull.Value : int.Parse(unidades));

                    int rowsAffected = command.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        // Update successful
                        MessageBox.Show("Projeto atualizado com sucesso.");
                    }
                    else
                    {
                        // Update failed
                        MessageBox.Show("Erro ao atualizar projeto!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return;
                    }
                }
            }
            catch (Exception ex)
            {
                // Tratamento de exceção
                if (ex.Message.Contains("A data de conclusão do projeto não pode ser menor que a duração do mesmo"))
                {
                    MessageBox.Show("A data de conclusão do projeto não pode ser menor que a duração do mesmo.");
                }
                else
                {
                    MessageBox.Show("Ocorreu um erro: " + ex.Message);
                }
            }


            this.Close();
            projetoCliente projetoCliente = new projetoCliente();
            projetoCliente.Show();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void comboBoxRef_SelectedIndexChanged_1(object sender, EventArgs e)
        {

        }

    }
}
