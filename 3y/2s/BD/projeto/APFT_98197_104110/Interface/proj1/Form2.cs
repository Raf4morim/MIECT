using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace proj1
{
    public partial class Form2 : Form
    {
        public Form2()
        {
            InitializeComponent();
        }

        private void Form2_Load(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            // Create an instance of Form1
            Form1 form1 = new Form1();

            // Display Form1
            form1.Show();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            // Create an instance of Form1
            projetoCliente projetoCliente = new projetoCliente();

            // Display Form1
            projetoCliente.Show();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void button3_Click(object sender, EventArgs e)
        {
            // Create an instance of Form1
            
            Material Material = new Material();

            // Display Form1
            Material.Show();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            cliente cliente = new cliente();

            // Display Form1
            cliente.Show();
        }
        private void panelContainer_Paint(object sender, PaintEventArgs e)
        {

        }

        private void button5_Click(object sender, EventArgs e)
        {
            AddRmv AddRmv = new AddRmv();

            // Display Form1
            AddRmv.Show();
        }
    }
}
