using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.ComponentModel.Design.ObjectSelectorEditor;

namespace proj1
{
    public partial class AddRmv : Form
    {
        private SqlConnection cn;
        public AddRmv()
        {
            InitializeComponent();
        }
        private void AddRmv_Load(object sender, EventArgs e)
        {
            cn = getSGBDConnection();
            PopulateNIFDropdown();
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

        private void PopulateNIFDropdown()
        {
            string queryNomeCliente = "SELECT cliente.FK_NIF, Nome FROM cliente INNER JOIN pessoa ON cliente.FK_NIF = pessoa.NIF";
            string queryID = "SELECT DISTINCT ID FROM projeto";
            string queryCodigo = "SELECT DISTINCT codigo from encomenda";
            string queryFuncs = "SELECT funcionario.FK_NIF, Nome FROM funcionario INNER JOIN pessoa ON funcionario.FK_NIF = pessoa.NIF";
            //string queryResponsavel = "SELECT distinct Nome, FK_NIF FROM pessoa INNER JOIN funcionario ON pessoa.NIF = funcionario.FK_NIF INNER JOIN responsavel ON funcionario.FK_NIF = responsavel.FK_NIF_Funcionario INNER JOIN projeto ON responsavel.FK_ID_Projeto = projeto.ID";


            SqlCommand commandID = new SqlCommand(queryID, cn);
            SqlCommand commandCodigo = new SqlCommand(queryCodigo, cn);
            SqlCommand commandNomeCliente = new SqlCommand(queryNomeCliente, cn);
            SqlCommand commandFuncs = new SqlCommand(queryFuncs, cn);
            SqlCommand commandResponsavel = new SqlCommand(queryFuncs, cn);


            cn.Open();

            SqlDataReader readerNomeResponsavel = commandResponsavel.ExecuteReader();

            while (readerNomeResponsavel.Read())
            {
                string nomeResponsavel = readerNomeResponsavel["Nome"].ToString();
                string NIFResponsavel = readerNomeResponsavel["FK_NIF"].ToString();
                comboBoxRmvResponsavel.Items.Add(nomeResponsavel + ", " + NIFResponsavel);
            }

            readerNomeResponsavel.Close();

            SqlDataReader readerNomefuncs = commandFuncs.ExecuteReader();

            while (readerNomefuncs.Read())
            {
                string nomeFuncs = readerNomefuncs["Nome"].ToString();
                string NIFFuncs = readerNomefuncs["FK_NIF"].ToString();
                comboBoxNIFFunc.Items.Add(nomeFuncs + ", " + NIFFuncs);
            }

            readerNomefuncs.Close();

            SqlDataReader readerNomeCliente = commandNomeCliente.ExecuteReader();

            while (readerNomeCliente.Read())
            {
                string nomeCliente = readerNomeCliente["Nome"].ToString();
                string NIFCliente = readerNomeCliente["FK_NIF"].ToString();
                comboBoxNomeCliente.Items.Add(nomeCliente + ", " + NIFCliente);
            }

            readerNomeCliente.Close();

            SqlDataReader readerID = commandID.ExecuteReader();

            while (readerID.Read())
            {
                int id = Convert.ToInt32(readerID["ID"]);
                comboBoxRmvProj.Items.Add(id);
                comboBoxIDdoResp.Items.Add(id);
            }

            readerID.Close();

            SqlDataReader readerCodigo = commandCodigo.ExecuteReader();

            while (readerCodigo.Read())
            {
                int Codigo = Convert.ToInt32(readerCodigo["Codigo"]);
                comboBoxRmvEncomenda.Items.Add(Codigo);
            }

            readerCodigo.Close();

            cn.Close();
        }

        private void button10_Click(object sender, EventArgs e)
        {
            this.Close();
            AddCliente AddCliente = new AddCliente();

            // Display Form1
            AddCliente.Show();
        }

        private void guna2Button5_Click(object sender, EventArgs e)
        {
            this.Close();
            Form1 form1 = new Form1();

            // Display Form1
            form1.Show();
        }

        private void guna2Button1_Click(object sender, EventArgs e)
        {

        }


        private void guna2Button2_Click(object sender, EventArgs e)
        {
            this.Close();
            projetoCliente projetoCliente = new projetoCliente();
            projetoCliente.Show();
        }

        private void guna2Button3_Click(object sender, EventArgs e)
        {
            this.Close();
            Material Material = new Material();
            Material.Show();
        }

        private void guna2Button4_Click(object sender, EventArgs e)
        {
            this.Close();
            cliente cliente = new cliente();
            cliente.Show();
        }

        private void rmvClient_Click(object sender, EventArgs e)
        {
            if (comboBoxNomeCliente.SelectedItem != null)
            {
                string nifToRemove = comboBoxNomeCliente.SelectedItem.ToString().PadRight(9);

                string[] parts = nifToRemove.Split(new string[] { ", " }, StringSplitOptions.None);

                string nome = parts[0];
                string nif = parts[1];
                try
                {
                    cn.Open();

                    // Excluir o cliente usando o comando DELETE
                    string deleteClienteQuery = "DELETE FROM cliente WHERE FK_NIF = @NIF";
                    SqlCommand deleteClienteCommand = new SqlCommand(deleteClienteQuery, cn);
                    deleteClienteCommand.Parameters.AddWithValue("@NIF", nif);
                    int rowsAffectedCliente = deleteClienteCommand.ExecuteNonQuery();

                    if (rowsAffectedCliente > 0)
                    {
                        // Registros removidos com sucesso
                        MessageBox.Show("Cliente removido com sucesso.");
                    }
                    else
                    {
                        // Nenhum registro foi removido da tabela "Cliente"
                        MessageBox.Show("Ao remover cliente. Nenhum registro foi excluído da tabela Cliente!", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Erro ao remover cliente: " + ex.Message);
                }
                finally
                {
                    cn.Close();
                }
            }
            else
            {
                MessageBox.Show("Selecione um cliente para remover.");
            }
        }


        private void comboBoxNIFFunc_SelectedIndexChanged(object sender, EventArgs e)
        {
        }

        //ADD and REMOVE FUNCIONÁRIO
        private void btnRmvFuncionario_Click(object sender, EventArgs e)
        {
            if (comboBoxNIFFunc.SelectedItem != null)
            {
                string funcToRemove = comboBoxNIFFunc.SelectedItem.ToString().PadRight(9);
                string[] parts = funcToRemove.Split(new string[] { ", " }, StringSplitOptions.None);

                string nome = parts[0];
                string nif = parts[1];
                cn = getSGBDConnection();

                try
                {
                    cn.Open();
                    string deleteFuncQuery = "delete from funcionario where FK_NIF = @funcToRemove";
                    SqlCommand deleteFuncCommand = new SqlCommand(deleteFuncQuery, cn);
                    deleteFuncCommand.Parameters.AddWithValue("@funcToRemove", nif);
                    int rowsAffectedFunc = deleteFuncCommand.ExecuteNonQuery();

                    if (rowsAffectedFunc == 0)
                    {
                        textBox4.Text = "";
                        MessageBox.Show("Funcionário não existe");
                        cn.Close();
                    }
                    else
                    {
                        textBox2.Text = "";
                        MessageBox.Show("Funcionário removido com sucesso!");
                        cn.Close();
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Funcionário inválido");
                    cn.Close();
                }
            }
            else
            {
                MessageBox.Show("Selecione um funcionário para remover.");
            }
            comboBoxNIFFunc.Text = "";
        }

        private void button9_Click(object sender, EventArgs e)
        {
            this.Close();
            AddFuncionario addFuncionario = new AddFuncionario();

            addFuncionario.Show();
        }

        //ADD and REMOVE projeto
        private void button7_Click(object sender, EventArgs e)
        {
            this.Close();
            AddProjeto addProjeto = new AddProjeto();

            addProjeto.Show();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            string idToDelete = comboBoxRmvProj.SelectedItem.ToString();

            if (string.IsNullOrEmpty(idToDelete))
            {
                MessageBox.Show("Por favor, insira o ID do projeto a ser removido.");
                return;
            }

            // Build the SQL query to delete the project with the specified ID
            string query = "DELETE FROM projeto WHERE ID = @ID";

            // Create a SqlCommand object with the query and connection
            SqlCommand command = new SqlCommand(query, cn);

            // Add the ID parameter to the command
            command.Parameters.AddWithValue("@ID", idToDelete);

            try
            {
                // Open the database connection
                cn.Open();

                // Execute the delete command
                int rowsAffected = command.ExecuteNonQuery();

                // Check if any rows were affected (project deleted)
                if (rowsAffected > 0)
                {
                    MessageBox.Show("Projeto removido com sucesso.");
                }
                else
                {
                    MessageBox.Show("Nenhum projeto foi removido. Verifique o ID do projeto.");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Ocorreu um erro ao remover o projeto: " + ex.Message);
            }
            finally
            {
                // Close the database connection
                cn.Close();
            }
        }

        //ADD and REMOVE encomenda
        private void button3_Click(object sender, EventArgs e)
        {

            //delete from encomenda where Codigo = 2;
            string codigoToDelete = comboBoxRmvEncomenda.SelectedItem?.ToString();


            if (string.IsNullOrEmpty(codigoToDelete))
            {
                MessageBox.Show("Por favor, insira o Código da encomenda que chegou.");
                return;
            }

            // Build the SQL query to delete the project with the specified ID
            string query = "DELETE FROM encomenda WHERE Codigo = @Codigo";

            // Create a SqlCommand object with the query and connection
            SqlCommand command = new SqlCommand(query, cn);

            // Add the ID parameter to the command
            command.Parameters.AddWithValue("@Codigo", codigoToDelete);

            try
            {
                // Open the database connection
                cn.Open();

                // Execute the delete command
                int rowsAffected = command.ExecuteNonQuery();

                // Check if any rows were affected (project deleted)
                if (rowsAffected > 0)
                {
                    MessageBox.Show("Chegada da encomenda registada com sucesso.");
                }
                else
                {
                    MessageBox.Show("Não foi possível registar a chegada da encomenda. Verifique o código da encomenda.");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Ocorreu um erro a registar a chegada da encomenda: " + ex.Message);
            }
            finally
            {
                // Close the database connection
                cn.Close();
            }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            this.Close();
            AddEncomenda addEncomenda = new AddEncomenda();

            addEncomenda.Show();
        }

        private void comboBoxRmvFornecedor_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        private void btnRvmResponsavel_Click(object sender, EventArgs e)
        {
            if (comboBoxRmvResponsavel.SelectedItem != null && comboBoxIDdoResp.SelectedItem != null)
            {
                string responsavelToRemove = comboBoxRmvResponsavel.SelectedItem.ToString().PadRight(9);
                string[] parts = responsavelToRemove.Split(new string[] { ", " }, StringSplitOptions.None);
                string idProjeto = comboBoxIDdoResp.SelectedItem.ToString();

                string nif = parts[1];
                cn = getSGBDConnection();

                try
                {
                    cn.Open();

                    // Verificar se o funcionário tem o projeto selecionado
                    string checkResponsavelQuery = "SELECT COUNT(*) FROM responsavel WHERE FK_NIF_Funcionario = @NIF AND FK_ID_Projeto = @IDProjeto";
                    SqlCommand checkResponsavelCommand = new SqlCommand(checkResponsavelQuery, cn);
                    checkResponsavelCommand.Parameters.AddWithValue("@NIF", nif);
                    checkResponsavelCommand.Parameters.AddWithValue("@IDProjeto", idProjeto);

                    int countResponsavel = (int)checkResponsavelCommand.ExecuteScalar();

                    if (countResponsavel == 0)
                    {
                        MessageBox.Show("O funcionário não está associado a esse projeto.");
                        cn.Close();
                        return;
                    }

                    // Remover o responsável
                    string deleteResponsavelQuery = "DELETE FROM responsavel WHERE FK_NIF_Funcionario = @NIF AND FK_ID_Projeto = @IDProjeto";
                    SqlCommand deleteResponsavelCommand = new SqlCommand(deleteResponsavelQuery, cn);
                    deleteResponsavelCommand.Parameters.AddWithValue("@NIF", nif);
                    deleteResponsavelCommand.Parameters.AddWithValue("@IDProjeto", idProjeto);

                    int rowsAffectedResponsavel = deleteResponsavelCommand.ExecuteNonQuery();

                    if (rowsAffectedResponsavel == 0)
                    {
                        MessageBox.Show("Erro ao remover o funcionário.");
                        cn.Close();
                    }
                    else
                    {

                        MessageBox.Show("Funcionário removido com sucesso!");
                        cn.Close();
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Ocorreu um erro ao remover o funcionário.");
                    cn.Close();
                }
            }
            else
            {
                MessageBox.Show("Verifique se esse funcionário tem o id selecionado ou se já não tem 2 projetos associados.");
            }
            comboBoxNIFFunc.Text = "";
        }

        private void button12_Click(object sender, EventArgs e)
        {

            addFornecedor addFornecedor = new addFornecedor();

            // Display Form1
            addFornecedor.Show();
        }

        private void comboBoxRmvResponsavel_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (comboBoxRmvResponsavel.SelectedItem != null)
            {
                string responsavelToRemove = comboBoxRmvResponsavel.SelectedItem.ToString().PadRight(9);
                string[] parts = responsavelToRemove.Split(new string[] { ", " }, StringSplitOptions.None);

                string nif = parts[1];

                try
                {
                    cn.Open();

                    // Consulta para obter os IDs dos responsáveis com base no NIF selecionado
                    string getIDsQuery = "SELECT FK_ID_Projeto FROM responsavel WHERE FK_NIF_Funcionario = @NIF";
                    SqlCommand getIDsCommand = new SqlCommand(getIDsQuery, cn);
                    getIDsCommand.Parameters.AddWithValue("@NIF", nif);

                    comboBoxIDdoResp.Items.Clear(); // Limpar os itens anteriores

                    using (SqlDataReader reader = getIDsCommand.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            comboBoxIDdoResp.Items.Add(reader["FK_ID_Projeto"].ToString());
                        }
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Erro ao obter IDs do responsavel: " + ex.Message);
                }
                finally
                {
                    cn.Close();
                }
            }
            else
            {
                MessageBox.Show("Selecione o NIF para obter os IDs.");
            }
        }


        private void comboBoxIDdoResp_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void btnAdicionarRespons_Click(object sender, EventArgs e)
        {
            if (comboBoxRmvResponsavel.SelectedItem != null && comboBoxIDdoResp.Text != null)
            {
                string responsavelToRemove = comboBoxRmvResponsavel.SelectedItem.ToString().PadRight(9);
                string[] parts = responsavelToRemove.Split(new string[] { ", " }, StringSplitOptions.None);
                int idProjeto = int.Parse(comboBoxIDdoResp.Text.Trim());
                string nif = parts[1];

                cn = getSGBDConnection();

                try
                {
                    cn.Open();

                    // Verificar se o responsável já está associado ao projeto
                    string checkQuery = "SELECT COUNT(*) FROM responsavel WHERE FK_NIF_Funcionario = @NIFFuncionario AND FK_ID_Projeto = @IDProjeto";
                    SqlCommand checkCommand = new SqlCommand(checkQuery, cn);
                    checkCommand.Parameters.AddWithValue("@NIFFuncionario", nif);
                    checkCommand.Parameters.AddWithValue("@IDProjeto", idProjeto);
                    int existingResponsavelCount = (int)checkCommand.ExecuteScalar();

                    if (existingResponsavelCount > 0)
                    {
                        MessageBox.Show("O funcionário já é responsável por este projeto.");
                        return;
                    }

                    // Inserir o novo responsável
                    string insertQuery = "INSERT INTO responsavel (FK_NIF_Funcionario, FK_ID_Projeto) VALUES (@NIFFuncionario, @IDProjeto)";
                    SqlCommand insertCommand = new SqlCommand(insertQuery, cn);
                    insertCommand.Parameters.AddWithValue("@NIFFuncionario", nif);
                    insertCommand.Parameters.AddWithValue("@IDProjeto", idProjeto);

                    // Executar o comando INSERT
                    int rowsAffected = insertCommand.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        MessageBox.Show("Responsável adicionado com sucesso.");
                    }
                    else
                    {
                        MessageBox.Show("Falha ao adicionar responsável.");
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Erro ao adicionar o responsável: " + ex.Message);
                }
                finally
                {
                    cn.Close();
                }
            }
            else
            {
                MessageBox.Show("Selecione o NIF e o ID do projeto para adicionar o responsável.");
            }
        }


        private void textBox5_TextChanged(object sender, EventArgs e)
        {

        }

        private void button11_Click(object sender, EventArgs e)
        {
            this.Close();
            EditarProj edit = new EditarProj();

            edit.Show();
        }

        private void label2_Click(object sender, EventArgs e)
        {

        }


        private void comboBoxNomeResponsavel_SelectedIndexChanged(object sender, EventArgs e)
        {
        }

        private void comboBoxNomeFuncionario_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void comboBoxNomeCliente_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void textBox4_TextChanged(object sender, EventArgs e)
        {

        }
    }
}
