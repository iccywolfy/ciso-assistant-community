from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('global_settings', '0003_alter_globalsettings_name'),
    ]

    operations = [
        migrations.AddField(
            model_name='globalsettings',
            name='logo',
            field=models.FileField(blank=True, null=True, upload_to='logos/', verbose_name='Custom Logo'),
        ),
    ]
