namespace CalificacionBancariaDesktop.ConsultaPlazoFijo
{
    partial class FormConsultaPlazoFijo
    {
        /// <summary>
        /// Variable del diseñador requerida.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Limpiar los recursos que se estén utilizando.
        /// </summary>
        /// <param name="disposing">true si los recursos administrados se deben eliminar; false en caso contrario, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Código generado por el Diseñador de Windows Forms

        /// <summary>
        /// Método necesario para admitir el Diseñador. No se puede modificar
        /// el contenido del método con el editor de código.
        /// </summary>
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.dgvPlazoFijo = new System.Windows.Forms.DataGridView();
            ((System.ComponentModel.ISupportInitialize)(this.dgvPlazoFijo)).BeginInit();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(12, 9);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(201, 24);
            this.label1.TabIndex = 26;
            this.label1.Text = "Listado de Plazos Fijos";
            // 
            // dgvPlazoFijo
            // 
            this.dgvPlazoFijo.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvPlazoFijo.Location = new System.Drawing.Point(8, 41);
            this.dgvPlazoFijo.Name = "dgvPlazoFijo";
            this.dgvPlazoFijo.Size = new System.Drawing.Size(712, 393);
            this.dgvPlazoFijo.TabIndex = 28;
            // 
            // FormConsultaPlazoFijo
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(728, 442);
            this.Controls.Add(this.dgvPlazoFijo);
            this.Controls.Add(this.label1);
            this.Name = "FormConsultaPlazoFijo";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Consulta de Plazos Fijos";
            this.Load += new System.EventHandler(this.FormConsultaPlazoFijo_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvPlazoFijo)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.DataGridView dgvPlazoFijo;
    }
}