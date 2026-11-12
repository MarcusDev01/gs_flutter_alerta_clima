import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';


enum NivelAlerta {
  atencao('Atenção', AppColors.nivelAtencao, 1),
  perigo('Perigo', AppColors.nivelPerigo, 2),
  grandePerigo('Grande perigo', AppColors.nivelGrandePerigo, 3);

  const NivelAlerta(this.rotulo, this.cor, this.peso);

  final String rotulo;
  final Color cor;
  final int peso;
}


enum TipoAlerta {
  chuvaForte(
    'Chuva forte',
    Icons.umbrella,
    'Risco de alagamentos, enxurradas e deslizamentos.',
    [
      'Não atravesse ruas ou pontes alagadas, nem a pé nem de carro.',
      'Desligue a energia elétrica se a água começar a entrar em casa.',
      'Em área de encosta, observe rachaduras e saia de casa se o terreno ceder.',
      'Guarde documentos e remédios em saco plástico em local alto.',
    ],
  ),
  calorExtremo(
    'Calor extremo',
    Icons.local_fire_department_outlined,
    'Temperaturas muito altas aumentam o risco de desidratação e insolação.',
    [
      'Beba água mesmo sem sede e ofereça água a idosos e crianças.',
      'Evite o sol entre 10h e 16h e atividades físicas intensas.',
      'Use roupas leves e mantenha a casa ventilada.',
      'Procure atendimento se houver tontura, confusão ou febre.',
    ],
  ),
  baixaUmidade(
    'Ar muito seco',
    Icons.opacity,
    'Umidade do ar baixa prejudica a respiração e favorece queimadas.',
    [
      'Beba bastante água e use soro nas narinas.',
      'Evite exercícios ao ar livre nas horas mais quentes.',
      'Use toalhas molhadas ou bacias de água nos ambientes.',
      'Não faça queimadas e denuncie focos de incêndio (193).',
    ],
  ),
  ventoForte(
    'Vento forte',
    Icons.air,
    'Rajadas podem derrubar árvores, postes e destelhar casas.',
    [
      'Não fique embaixo de árvores, placas ou estruturas metálicas.',
      'Recolha objetos soltos em quintais e varandas.',
      'Afaste-se de fios caídos e avise a distribuidora de energia.',
    ],
  ),
  radiacaoUv(
    'Radiação UV extrema',
    Icons.wb_sunny_outlined,
    'Exposição ao sol pode causar queimaduras em poucos minutos.',
    [
      'Use protetor solar, chapéu e óculos escuros.',
      'Prefira a sombra entre 10h e 16h.',
      'Proteja especialmente crianças e trabalhadores ao ar livre.',
    ],
  ),
  frioIntenso(
    'Frio intenso',
    Icons.ac_unit,
    'Baixas temperaturas são perigosas para idosos, bebês e pessoas em situação de rua.',
    [
      'Agasalhe-se em camadas e proteja mãos, pés e cabeça.',
      'Nunca use fogareiro ou braseiro em ambiente fechado.',
      'Ao ver alguém em situação de rua com frio, ligue para a assistência social da cidade.',
    ],
  );

  const TipoAlerta(this.rotulo, this.icone, this.descricao, this.recomendacoes);

  final String rotulo;
  final IconData icone;
  final String descricao;
  final List<String> recomendacoes;
}


class Alerta {
  const Alerta({
    required this.tipo,
    required this.nivel,
    required this.data,
    required this.detalhe,
  });

  final TipoAlerta tipo;
  final NivelAlerta nivel;
  final DateTime data;

  
  final String detalhe;
}
