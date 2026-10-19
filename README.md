# RIKO

Sistema de finanças da casa: salários, ganhos extra, contas fixas (valor ou percentagem do salário), gastos do mês, metas com percentagem automática da sobra, gráficos, evolução mensal e totais acumulados.

O site é um único ficheiro `index.html`, sem instalação nem build.

## Onde ficam os dados
- **Com Supabase configurado** (recomendado): os dados ficam na nuvem, numa tabela do seu projeto Supabase. Entra-se com email e senha, e quem usar a mesma conta vê os mesmos dados em qualquer telemóvel ou computador, atualizados em tempo real.
- **Sem Supabase**: os dados ficam só no navegador (localStorage). Cada aparelho tem os seus próprios dados, e limpar os dados do navegador apaga-os.

## Ligar ao Supabase
1. Em supabase.com, crie um projeto (o plano gratuito chega).
2. Abra **SQL Editor → New query**, cole o conteúdo de `supabase.sql` e clique em **Run**.
3. Em **Authentication → Sign In / Providers → Email**, desligue **Confirm email** (opcional, mas assim pode entrar logo depois de criar a conta).
4. Em **Project Settings → API**, copie o **Project URL** e a chave **anon public**.
5. No `index.html`, procure `SUPABASE_URL` e cole os dois valores entre as aspas:
   ```js
   const SUPABASE_URL = 'https://xxxxxxxx.supabase.co';
   const SUPABASE_ANON_KEY = 'eyJhbGciOi...';
   ```
   A chave anon pode ficar no site: só deixa cada conta ler e alterar os seus próprios dados (regras RLS do `supabase.sql`).
6. Envie o `index.html` para o repositório no GitHub; o Vercel atualiza o site sozinho.

## Como publicar no Vercel
1. Em vercel.com, clique em **Add New → Project**.
2. Escolha o repositório **RIKO** e clique em **Import**.
3. Em *Framework Preset* deixe **Other** e clique em **Deploy**.
